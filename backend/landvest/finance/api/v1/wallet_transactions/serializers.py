from rest_framework import serializers


from landvest.utils import (
    get_flutterwave_transaction_details,
    generate_transaction_id,
    FWSTATUS_CHOICES,
)

from landvest.finance.models import Wallet, WalletTransaction, Webhook


base_fields = [
    "id",
    "date_created",
    "date_modified",
]

base_extra_kwargs = {
    "date_created": {"read_only": True},
    "date_modified": {"read_only": True},
    "id": {"read_only": True},
}


class WalletTransactionSerializer(serializers.ModelSerializer):
    class Meta:
        model = WalletTransaction
        fields = [
            *base_fields,
            "internal_transaction_id",
            "external_transaction_id",
            "transaction_type",
            "status",
            "balance_on_transaction",
            "amount",
            "source",
            "destination",
        ]
        extra_kwargs = {
            **base_extra_kwargs,
            "internal_transaction_id": {"read_only": True},
            "external_transaction_id": {"read_only": True},
            "transaction_type": {"read_only": True},
            "status": {"read_only": True},
            "balance_on_transaction": {"read_only": True},
            "amount": {"read_only": True},
            "source": {"read_only": True},
            "destination": {"read_only": True},
        }


class WalletTransactionTopupSerializer(serializers.ModelSerializer):
    class Meta:
        model = WalletTransaction
        fields = [
            "external_transaction_id",
        ]
        extra_kwargs = {
            "external_transaction_id": {"write_only": True, "required": True},
        }

    def save(self, *args, **kwargs):
        user = self.context["request"].user
        data = self.validated_data
        transaction_id = data["external_transaction_id"]
        external_transaction_id = transaction_id
        email = user.email
        try:
            user_wallet = Wallet.objects.get(user=user)
        except:
            raise serializers.ValidationError(
                {"message": "This user doesn't have a wallet !"}
            )
        # check if wallettransaction with transaction_id exists
        transaction = (
            WalletTransaction.objects.only("external_transaction_id", "wallet")
            .select_related("wallet")
            .filter(
                external_transaction_id=external_transaction_id,
                wallet__user__email=email,
            )
            .first()
        )
        # check if webhook with that transaction_id and email exists
        webhook = (
            Webhook.objects.only("transaction_id", "email")
            .filter(transaction_id=transaction_id, email=email)
            .first()
        )
        if webhook:
            import json

            # get details from webhook
            payload = json.loads(webhook.body)
            wdata = payload["data"]
            wstatus = wdata["status"]
            wamount = wdata["amount"]
            if transaction:
                # - if it exists: update the status and details
                balance_on_transaction = transaction.wallet.current_balance
                transaction.status = FWSTATUS_CHOICES.get(wstatus, "PENDING")
                transaction.amount = wamount
                transaction.balance_on_transaction = balance_on_transaction
                transaction.save()
            else:
                # - else: create one using email and transaction_id from webhook
                source = "EXTERNAL"
                destination = "WALLET"
                transaction_type = "CREDIT"
                internal_transaction_id = generate_transaction_id()
                external_transaction_id = transaction_id
                wtransaction = user_wallet.transactions.create(
                    source=source,
                    destination=destination,
                    internal_transaction_id=internal_transaction_id,
                    external_transaction_id=external_transaction_id,
                    transaction_type=transaction_type,
                )
                if wstatus == "successful":
                    balance_on_transaction = user_wallet.current_balance
                    transaction.status = FWSTATUS_CHOICES.get(wstatus, "PENDING")
                    transaction.amount = wamount
                    transaction.balance_on_transaction = balance_on_transaction
                    transaction.save()
            # - delete webhook
            print("webhook deleted !", webhook)
            webhook.delete()
        else:
            # - else: create one using email and transaction_id
            # get transaction id
            try:
                details = get_flutterwave_transaction_details(transaction_id)
                wdata = details["data"]
                tstatus = wdata["status"]
                amount = wdata["amount"]
            except:
                raise serializers.ValidationError(
                    {"message": "Transaction not found !"}
                )
            # create wallet transaction
            source = "EXTERNAL"
            destination = "WALLET"
            transaction_type = "CREDIT"
            internal_transaction_id = generate_transaction_id()
            external_transaction_id = transaction_id
            transaction = (
                WalletTransaction.objects.only("external_transaction_id", "wallet")
                .select_related("wallet")
                .filter(
                    external_transaction_id=external_transaction_id,
                    wallet__user__email=email,
                )
                .first()
            )
            # - check if transaction_id with user email exists
            if transaction:
                # - if it exists: update the status and details
                balance_on_transaction = transaction.wallet.current_balance
                transaction.status = FWSTATUS_CHOICES.get(tstatus, "PENDING")
                transaction.amount = amount
                transaction.balance_on_transaction = balance_on_transaction
                transaction.save()
            else:
                wtransaction = user_wallet.transactions.create(
                    source=source,
                    destination=destination,
                    internal_transaction_id=internal_transaction_id,
                    external_transaction_id=external_transaction_id,
                    transaction_type=transaction_type,
                )
                if tstatus == "successful":
                    balance_on_transaction = wtransaction.wallet.current_balance
                    wtransaction.amount = amount
                    wtransaction.balance_on_transaction = balance_on_transaction
                    wtransaction.status = FWSTATUS_CHOICES.get(tstatus, "PENDING")
                    wtransaction.save()
        r = {"message": "Success !"}
        return r
