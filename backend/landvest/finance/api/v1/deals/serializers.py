from rest_framework import serializers

from landvest.finance.models import Deal as DealType
from landvest.finance.models import DealImage, DealPrice

base_user_fields = [
    "id",
    "is_active",
    "date_created",
    "date_modified",
]


class DealPriceSerializer(serializers.ModelSerializer[DealPrice]):
    class Meta:
        model = DealPrice
        fields = [
            *base_user_fields,
            "price",
        ]


class DealImageSerializer(serializers.ModelSerializer[DealImage]):
    class Meta:
        model = DealImage
        fields = [
            *base_user_fields,
            "image",
        ]


class DealSerializer(serializers.ModelSerializer[DealType]):
    class Meta:
        model = DealType
        fields = [
            *base_user_fields,
            "title",
            "description",
            "location",
            "thumbnail",
            "units",
            "area",
            "can_outright",
            "is_featured",
            "maturity_date",
            "current_price",
        ]


class DealDetailSerializer(serializers.ModelSerializer[DealType]):
    gallery = DealImageSerializer(many=True, read_only=True)
    prices = DealPriceSerializer(many=True, read_only=True)

    class Meta:
        model = DealType
        fields = [
            *base_user_fields,
            "title",
            "description",
            "location",
            "thumbnail",
            "units",
            "area",
            "can_outright",
            "maturity_date",
            "current_price",
            "prices",
            "gallery",
        ]
