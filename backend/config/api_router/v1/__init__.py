from django.conf import settings
from rest_framework.routers import DefaultRouter, SimpleRouter

from landvest.users.api.v1.users.views import UserViewSet
from landvest.finance.api.v1.deals.views import DealViewSet
from landvest.finance.api.v1.wallet.views import WalletViewSet
from landvest.finance.api.v1.savings.views import SavingsViewSet


if settings.DEBUG:
    router = DefaultRouter()
else:
    router = SimpleRouter()

router.register("users", UserViewSet, basename="users")
router.register("deals", DealViewSet, basename="deals")
router.register("wallets", WalletViewSet, basename="wallets")
router.register("savings", SavingsViewSet, basename="savings")


app_name = "v1"
urlpatterns = router.urls
