from rest_framework import status
from rest_framework.decorators import action
from rest_framework.mixins import ListModelMixin, RetrieveModelMixin
from rest_framework.parsers import JSONParser
from rest_framework.response import Response

from django.utils.decorators import method_decorator
from django.db import transaction

from rest_framework import permissions

from landvest.finance.models import Savings, Wallet
from landvest.mixins import MultiSerializerClassMixin

from landvest.users.api.v1.users.views import RequestViewSet
from landvest.finance.api.v1.savings.serializers import (
    SavingsToWalletWithdrawal,
    UserSavingsSerializer,
    UpdateSavingsSerializer,
    CreateSavingsSerializer,
    WalletToSavingsTopUp,
)
from landvest.finance.api.v1.savings_transactions.serializers import (
    SavingsTransactionSerializer,
)
from landvest.finance.api.v1.savings.utils import user_passes_savings_test


class SavingsViewSet(
    ListModelMixin,
    RetrieveModelMixin,
    MultiSerializerClassMixin,
    RequestViewSet,
):
    queryset = Savings.objects.filter(is_active=True)
    serializer_class = UserSavingsSerializer
    lookup_field = "pk"
    parser_classes = [JSONParser]
    permission_classes = [permissions.IsAuthenticated]
    serializer_action_classes = {
        "create": CreateSavingsSerializer,
        "update": UpdateSavingsSerializer,
        "transactions": SavingsTransactionSerializer,
        "withdrawal_to_wallet": SavingsToWalletWithdrawal,
        "topup_from_wallet": WalletToSavingsTopUp,
    }

    def list(self, *args, **kwargs):
        user = self.request.user
        savings = self.queryset.filter(user=user)
        serializer = self.get_serializer(savings, many=True)
        return Response(data=serializer.data, status=status.HTTP_200_OK)

    def create(self, *args, **kwargs):
        with transaction.atomic():
            data = self.request.data
            final_data = {**data, "user": self.request.user.id}
            serializer = self.get_serializer(data=final_data)
            if serializer.is_valid(raise_exception=True):
                serializer.save()
            return Response(data=serializer.data, status=status.HTTP_201_CREATED)

    def user_owns_savings(user_id, savings_id):
        # check if the item to be updated belongs to the user
        return (
            Savings.objects.only("id", "user_id")
            .filter(id=savings_id, user_id=user_id)
            .exists()
        )

    @method_decorator(user_passes_savings_test(user_owns_savings))
    def retrieve(self, *args, **kwargs):
        return super().retrieve(*args, **kwargs)

    @method_decorator(user_passes_savings_test(user_owns_savings))
    def update(self, *args, **kwargs):
        with transaction.atomic():
            instance = self.get_object()
            data = self.request.data

            serializer = self.get_serializer(instance=instance, data=data)

            if serializer.is_valid(raise_exception=True):
                serializer.save()

            return Response(data=serializer.data, status=status.HTTP_200_OK)

    @action(detail=True, methods=["get"])
    @method_decorator(user_passes_savings_test(user_owns_savings))
    def transactions(self, request, *args, **kwargs):
        instance = self.get_object()
        queryset = instance.transactions.filter(is_active=True)
        serializer = self.get_serializer(queryset, many=True)
        return Response(status=status.HTTP_200_OK, data=serializer.data)

    # savings withdrawal
    # /api/v1/savings/1/withdrawal-to-wallet/
    @method_decorator(user_passes_savings_test(user_owns_savings))
    @action(detail=True, methods=['post'], url_path='withdrawal-to-wallet')
    def withdrawal_to_wallet(self, *args, **kwargs):
        # get user
        user = self.request.user
        # get savings
        savings:Savings = self.get_object()
        # get user wallet
        try:
            user_wallet = Wallet.objects.get(user=user)
        except:
            return Response(
                {"message": "You don't have a wallet !"},
                status=status.HTTP_403_FORBIDDEN
            )
        # check if the savings is empty
        if savings.current_balance == 0:
            return Response("This savings is empty !", status=status.HTTP_403_FORBIDDEN)
        serializer = self.get_serializer(instance=savings ,data={
            'id': savings.id
        })
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response("Withdrawal Was Successful !", status=status.HTTP_200_OK)

    # savings topup
    # /api/v1/savings/1/topup-from-wallet/
    @method_decorator(user_passes_savings_test(user_owns_savings))
    @action(detail=True, methods=['post'], url_path='topup-from-wallet')
    def topup_from_wallet(self, *args, **kwargs):
        data = self.request.data
        # get user
        user = self.request.user
        # get savings
        savings:Savings = self.get_object()
        # get amount
        amount = data.get('amount', 0)
        # get user wallet
        try:
            user_wallet = Wallet.objects.get(user=user)
        except:
            return Response(
                {"message": "You don't have a wallet !"},
                status=status.HTTP_403_FORBIDDEN
            )
        # check if the savings is empty
        if user_wallet.current_balance == 0:
            return Response("Your wallet is empty !", status=status.HTTP_403_FORBIDDEN)
        # check if wallet balance is lower than amount to be deposited
        if user_wallet.current_balance < amount:
            return Response("Insufficient Funds !", status=status.HTTP_403_FORBIDDEN)

        serializer = self.get_serializer(instance=savings, data=data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response("Topup Was Successful !", status=status.HTTP_200_OK)
