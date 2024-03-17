from rest_framework_simplejwt.tokens import RefreshToken
from django.conf import settings
import random, string, requests, uuid
from django.contrib.auth.tokens import PasswordResetTokenGenerator
from six import text_type


class TokenGenerator(PasswordResetTokenGenerator):
    def _make_hash_value(self, user, timestamp):
        return text_type(user.pk) + text_type(timestamp) + text_type(user.is_verified)


account_activation_token = TokenGenerator()


def get_tokens_for_user(user):
    refresh = RefreshToken.for_user(user)

    return {
        "refresh": str(refresh),
        "access": str(refresh.access_token),
    }


# generate 5 number and letters characters
def generate_numbers_token(count=1):
    return "".join(random.choices(string.digits, k=count))


def flutterwave_verify_transaction(price, id):
    details = get_flutterwave_transaction_details(id)
    data = details["data"]
    status = data["status"]
    amount = data["amount"]
    return status == "successful" and price == amount


def get_flutterwave_transaction_details(transaction_id):
    endpoint = f"https://api.flutterwave.com/v3/transactions/{transaction_id}/verify"
    headers = {"Authorization": f"Bearer {settings.FLUTTERWAVE_SK}"}
    response = requests.get(url=endpoint, headers=headers)
    return response.json()


def generate_transaction_id():
    # generate transaction is using crypto
    id = uuid.uuid1()
    return id.hex


def get_origin(request):
    origin = request.build_absolute_uri().split("/")[:3]
    origin = "/".join(origin)
    return origin


FWSTATUS_CHOICES = {
    "PENDING": "PENDING",
    "successful": "SUCCESS",
    "failed": "FAILED",
}

def get_percentage_of_amount(percentage=0, amount=0):
    percentage_ = 0
    amount_ = 0

    try:
        percentage_ = float(percentage)
    except:
        percentage_ = 0
    try:
        amount_ = float(amount)
    except:
        amount_ = 0

    if percentage_ == 0:
        return 0
    if percentage_ == 100:
        return amount_

    return (percentage_/100)*amount_
