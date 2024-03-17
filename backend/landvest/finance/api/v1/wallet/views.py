from rest_framework import status
from rest_framework.decorators import action
from rest_framework.mixins import ListModelMixin
from rest_framework.parsers import JSONParser
from rest_framework.response import Response
from django.db import transaction
from rest_framework import permissions


from landvest.finance.models import Wallet
from landvest.mixins import MultiSerializerClassMixin

from landvest.users.api.v1.users.views import RequestViewSet
from landvest.finance.api.v1.wallet.serializers import (
    WalletSerializer,
    CreateWalletSerializer,
)
from landvest.finance.api.v1.wallet_transactions.serializers import (
    WalletTransactionSerializer,
    WalletTransactionTopupSerializer,
)


class WalletViewSet(
    ListModelMixin,
    MultiSerializerClassMixin,
    RequestViewSet,
):
    queryset = Wallet.objects.filter(is_active=True)
    serializer_class = WalletSerializer
    lookup_field = "pk"
    parser_classes = [JSONParser]
    permission_classes = [permissions.IsAuthenticated]
    serializer_action_classes = {
        "create_wallets": CreateWalletSerializer,
        "transactions": WalletTransactionSerializer,
        "topup": WalletTransactionTopupSerializer,
    }
    permissions_action_classes = {}

    def get_queryset(self):
        queryset = (
            super().get_queryset().select_related("user").prefetch_related("transactions").order_by("-date_created")
        )
        return queryset.filter(user=self.request.user)

    # fresh endpoints
    @action(detail=True, methods=["get"])
    def transactions(self, request, *args, **kwargs):
        instance: Wallet = self.get_object()
        queryset = instance.transactions.filter(is_active=True)
        serializer = self.get_serializer(queryset, many=True)
        return Response(status=status.HTTP_200_OK, data=serializer.data)

    # topup wallets
    # /api/wallets/topup/
    @action(detail=False, methods=["post"])
    def topup(self, request, *args, **kwargs):
        data = request.data
        with transaction.atomic():
            serializer = self.get_serializer(data=data)
            serializer.is_valid(raise_exception=True)
            response = serializer.save()
        return Response(status=status.HTTP_200_OK, data=response)

    # fresh endpoints
