from django.urls import reverse
from django.utils import timezone
from datetime import timedelta

from landvest.tests.globals.v1 import GlobalAPITestCase
from landvest.finance.api.v1.savings.utils import parseDateTime

from rest_framework import status

# serializers

# models
from landvest.finance.models import Deal


class DealViewSetAPITestCase(GlobalAPITestCase):
    def setUp(self) -> None:
        # endpoints
        self.all_investment_deals_url = reverse("api:v1:deals-all-investment-deals")
        self.featured_investment_deals_url = reverse("api:v1:deals-featured-investment-deals")
        self.investment_deals_detail_url = reverse("api:v1:deals-investment-deals-detail", kwargs={"pk": 1})
        return super().setUp()

    def test_all_investment_deals_url(self):
        self.assertEqual(
            self.all_investment_deals_url,
            "/api/v1/deals/all-investment-deals/",
        )

    def test_featured_investment_deals_url(self):
        self.assertEqual(
            self.featured_investment_deals_url,
            "/api/v1/deals/featured-investment-deals/",
        )

    def test_investment_deals_detail_url(self):
        self.assertEqual(
            self.investment_deals_detail_url,
            "/api/v1/deals/1/investment-deals-detail/",
        )

    def create_deal(self):
        # create deal and returns deal
        deal = Deal()
        deal.title = "30 Quality Plots"
        deal.description = "Nice Location"
        deal.owner = self.auth_user
        deal.location = "Soltec, Agu-awka"
        deal.units = 10
        deal.can_outright = True
        deal.maturity_date = timezone.now() + timedelta(weeks=4)
        deal.area = 400
        deal.save()
        return deal

    def create_featured_deal(self):
        # create deal and returns deal
        deal = Deal()
        deal.title = "30 Quality Plots"
        deal.description = "Nice Location"
        deal.owner = self.auth_user
        deal.location = "Soltec, Agu-awka"
        deal.units = 10
        deal.can_outright = True
        deal.is_featured = True
        deal.maturity_date = timezone.now() + timedelta(weeks=4)
        deal.area = 400
        deal.save()
        return deal

    def test_fetchingAllInvestmentDeals_shouldBeSuccessful(self):
        # check for empty deals
        response = self.client.get(self.all_investment_deals_url)
        # test for status 200
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # test for empty response
        self.assertEqual(response.data, list())
        # gets created deal
        deal = self.create_deal()
        # check for one deal
        response = self.client.get(self.all_investment_deals_url)
        # test for status 200
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # test for only one data been returned in response data
        self.assertEqual(len(response.data), 1)
        # check single deal
        single_deal = response.data[0]
        self.assertEqual(single_deal["title"], deal.title)
        self.assertEqual(single_deal["description"], deal.description)
        self.assertEqual(single_deal["location"], deal.location)
        self.assertEqual(single_deal["units"], deal.units)
        self.assertEqual(single_deal["area"], deal.area)
        self.assertEqual(single_deal["can_outright"], deal.can_outright)
        self.assertEqual(parseDateTime(single_deal["maturity_date"]), deal.maturity_date)
        self.assertEqual(single_deal["current_price"], 0)

    def test_fetchingFeaturedInvestmentDeals_shouldBeSuccessful(self):
        # gets created deal
        self.create_deal()
        # check for one deal
        response = self.client.get(self.all_investment_deals_url)
        # test for status 200
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # test for only one data been returned in response data
        self.assertEqual(len(response.data), 1)
        # gets created featured deal and test
        self.create_featured_deal()
        # check for two deals
        response = self.client.get(self.all_investment_deals_url)
        # test for status 200
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # test for empty response
        self.assertEqual(len(response.data), 2)
        # check for one featured deal
        response = self.client.get(self.featured_investment_deals_url)
        # test for status 200
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # test for empty response
        self.assertEqual(len(response.data), 1)
        # test if the deal is featured
        featured_deals = response.data[0]
        self.assertTrue(featured_deals['is_featured'])

    def test_fetchingSingleInvestmentDealDetails_shouldBeSuccessful(self):
        # check for empty 404 deals
        response = self.client.get(self.investment_deals_detail_url)
        # test for status 200
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
        # gets created deal
        deal = self.create_deal()
        # check for one deal
        self.investment_deals_detail_url = reverse("api:v1:deals-investment-deals-detail", kwargs={"pk": deal.id})
        response = self.client.get(self.investment_deals_detail_url)
        # test for status 200
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # test for empty response
        self.assertEqual(response.data["title"], deal.title)
        self.assertEqual(response.data["description"], deal.description)
        self.assertEqual(response.data["location"], deal.location)
        self.assertEqual(response.data["units"], deal.units)
        self.assertEqual(response.data["area"], deal.area)
        self.assertEqual(response.data["can_outright"], deal.can_outright)
        self.assertEqual(parseDateTime(response.data["maturity_date"]), deal.maturity_date)
        self.assertEqual(response.data["current_price"], 0)
