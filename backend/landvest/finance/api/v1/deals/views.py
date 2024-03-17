from rest_framework import status
from rest_framework.decorators import action
from rest_framework.mixins import ListModelMixin
from rest_framework.parsers import JSONParser, MultiPartParser
from rest_framework.response import Response

from landvest.finance.models import Deal
from landvest.mixins import MultiSerializerClassMixin

from landvest.finance.api.v1.deals.serializers import (
    DealDetailSerializer,
    DealSerializer,
)
from landvest.users.api.v1.users.views import RequestViewSet


class DealViewSet(
    ListModelMixin,
    MultiSerializerClassMixin,
    RequestViewSet,
):
    queryset = Deal.objects.filter(is_active=True)
    serializer_class = DealSerializer
    lookup_field = "pk"
    parser_classes = [MultiPartParser, JSONParser]
    serializer_action_classes = {"investment_deals_detail": DealDetailSerializer}

    # all investment deals
    # /deals/all-investment-deals/
    @action(detail=False, methods=["get"], url_path="all-investment-deals")
    def all_investment_deals(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        return Response(status=status.HTTP_200_OK, data=serializer.data)

    # featured investment deals
    # /deals/featured-investment-deals/
    @action(detail=False, methods=["get"], url_path="featured-investment-deals")
    def featured_investment_deals(self, request, *args, **kwargs):
        queryset = self.get_queryset().filter(is_featured=True)
        serializer = self.get_serializer(queryset, many=True)
        return Response(status=status.HTTP_200_OK, data=serializer.data)

    # investment deals detail
    # /deals/<pk>/investment-deals-detail/
    @action(detail=True, methods=["get"], url_path="investment-deals-detail")
    def investment_deals_detail(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance, many=False)
        return Response(status=status.HTTP_200_OK, data=serializer.data)
