from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST
from rest_framework.decorators import permission_classes
from django.http import JsonResponse
from django.shortcuts import render, redirect
from django.utils.encoding import force_str
from django.utils.http import urlsafe_base64_decode
from django.contrib import messages
from django.conf import settings

from rest_framework import permissions

from landvest.finance.models import WalletTransaction, Webhook
from landvest.users.models import User

from landvest.utils import account_activation_token, FWSTATUS_CHOICES
import json


@csrf_exempt
@require_POST
@permission_classes([permissions.AllowAny])
def webhook(request, *args, **kwargs):
    secret_hash = settings.FLUTTERWAVE_SH
    signature = request.META.get("HTTP_VERIF_HASH")
    charge_completed = "charge.completed"

    if signature == None or (signature != secret_hash):
        return JsonResponse({"message": "error"})

    payload = json.loads(request.body)
    data = payload["data"]
    status = data["status"]
    amount = data["amount"]
    event = payload["event"]
    customer = data["customer"]
    email = customer["email"]

    try:
        if event == charge_completed:
            r_id = data["id"]
            transaction = (
                WalletTransaction.objects.only("external_transaction_id", "wallet")
                .select_related("wallet")
                .filter(external_transaction_id=r_id, wallet__user__email=email)
                .first()
            )
            # - check if transaction_id with user email exists
            if transaction:
                # - if it exists: update the status and details
                balance_on_transaction = transaction.wallet.current_balance
                transaction.status = FWSTATUS_CHOICES.get(status, "PENDING")
                transaction.amount = amount
                transaction.balance_on_transaction = balance_on_transaction
                transaction.save()
            else:
                # - else: create one using email and transaction_id and create webhook
                web_hook, __ = Webhook.objects.get_or_create(
                    transaction_id=r_id,
                    email=email,
                )
                web_hook.body = json.dumps(payload)
                web_hook.save()
    except:
        pass
    return JsonResponse({"message": "Webhook Received !"})


def verify_email_complete(request):
    return render(request, "user/verify_email_complete.html")


def verify_email_confirm(request, uidb64, token):
    try:
        uid = force_str(urlsafe_base64_decode(uidb64))
        user = User.objects.get(pk=uid)
    except (TypeError, ValueError, OverflowError, User.DoesNotExist):
        user = None
    if user is not None and account_activation_token.check_token(user, token):
        user.is_verified = True
        user.save()
        messages.success(request, "Your email has been verified.")
        return redirect("api:verify-email-complete")
    else:
        messages.warning(request, "The link is invalid.")
    return render(request, "user/verify_email_confirm.html")


def custom404(request, exception=None):
    return JsonResponse({"status_code": 404, "error": "The resource was not found"})


def custom500(request, exception=None):
    return JsonResponse({"status_code": 500, "error": "Server Error"})


def custom400(request, exception=None):
    return JsonResponse({"status_code": 400, "error": "Bad Request!"})


def custom403(request, exception=None):
    return JsonResponse({"status_code": 403, "error": "Permission Denied"})
