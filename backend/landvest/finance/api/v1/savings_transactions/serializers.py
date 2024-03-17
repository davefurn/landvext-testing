from rest_framework import serializers
from landvest.finance.models import SavingsTransaction

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


class SavingsTransactionSerializer(serializers.ModelSerializer):
    class Meta:
        model = SavingsTransaction
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
