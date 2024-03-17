from rest_framework import serializers
from landvest.finance.models import Wallet
from landvest.users.api.v1.users.serializers import CustomUserSerializer
from landvest.finance.api.v1.wallet_transactions.serializers import (
    WalletTransactionSerializer,
)


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


class WalletSerializer(serializers.ModelSerializer):
    user = CustomUserSerializer(many=False, read_only=True)

    class Meta:
        model = Wallet
        fields = [
            *base_fields,
            "user",
            "current_balance",
        ]
        extra_kwargs = {
            **base_extra_kwargs,
            "current_balance": {"read_only": True},
        }


class CreateWalletSerializer(serializers.ModelSerializer):
    class Meta:
        model = Wallet
        fields = [
            *base_fields,
            "user",
            "current_balance",
        ]
        extra_kwargs = {
            **base_extra_kwargs,
            "current_balance": {"read_only": True},
        }


class UserWalletSerializer(serializers.ModelSerializer):
    class Meta:
        model = Wallet
        fields = [
            *base_fields,
            "current_balance",
        ]
        extra_kwargs = {
            **base_extra_kwargs,
            "current_balance": {"read_only": True},
        }


class UserWalletWithTransactionsSerializer(serializers.ModelSerializer):
    transactions = WalletTransactionSerializer(many=True, read_only=True)

    class Meta:
        model = Wallet
        fields = [
            *base_fields,
            "current_balance",
            "transactions",
        ]
        extra_kwargs = {
            **base_extra_kwargs,
            "current_balance": {"read_only": True},
        }
