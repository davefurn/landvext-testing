import json
from django.conf import settings
from django.urls import reverse
from rest_framework import status
from landvest.utils import generate_numbers_token, get_flutterwave_transaction_details
from landvest.users.models import User
from landvest.finance.models import (
    Wallet,
    WalletTransaction,
    Webhook,
)
from landvest.tests.globals.v1 import GlobalAPITestCase

# serializers

# models


class WalletViewSetAPITestCase(GlobalAPITestCase):
    def setUp(self) -> None:
        self.signup_url = reverse("api:v1:users-signup")
        self.transactions_url = reverse("api:v1:wallets-transactions", kwargs={"pk": 2})
        self.topup_url = reverse("api:v1:wallets-topup")
        self.assertEqual(self.transactions_url, "/api/v1/wallets/2/transactions/")
        self.assertEqual(self.topup_url, "/api/v1/wallets/topup/")

        return super().setUp()

    def create_webhook(self):
        # create wehbook and return created webhook
        r_id = generate_numbers_token(20)
        email = self.auth_email
        payload = {}
        # - else: create one using email and transaction_id and create webhook
        web_hook, __ = Webhook.objects.get_or_create(
            transaction_id=r_id,
            email=email,
        )
        web_hook.body = json.dumps(payload)
        web_hook.save()
        return web_hook

    def test_topup(self):
        self.client.force_authenticate(self.auth_user)
        webhook = self.create_webhook()
        transaction_id = webhook.transaction_id
        data = {"external_transaction_id": transaction_id}
        response = self.client.post(self.topup_url, data)
        pass

    def create_user_wallet(self):
        data = {
            "email":  "izuchukwu2@gmail.com",
            "first_name":  "Emmanuel",
            "last_name":  "Django",
            "password":  "09155202857",
            "phone_number":  "29155202859",
        }
        response = self.client.post(self.signup_url, data)
        # get user wallet
        wallet = Wallet.objects.get(user__email="izuchukwu2@gmail.com")
        return wallet

    def create_user_wallet_transaction(self, wallet):
        amount = 434
        balance_on_transaction = 1200
        internal_transaction_id = generate_numbers_token(count=16)
        external_transaction_id = generate_numbers_token(count=16)
        user_wallet_transaction = WalletTransaction.objects.create(
            wallet=wallet,
            transaction_type="CREDIT",
            internal_transaction_id=internal_transaction_id,
            external_transaction_id=external_transaction_id,
            amount=amount,
            balance_on_transaction=balance_on_transaction,
        )
        return user_wallet_transaction

    def test_fetchingWalletTransactions_shouldBeSuccessful(self):
        # get created wallet
        wallet  = self.create_user_wallet()
        # get user
        user = wallet.user
        # create wallet transactions
        user_wallet_transaction = self.create_user_wallet_transaction(wallet)
        # authenticate user
        self.client.force_authenticate(user)
        url = reverse("api:v1:wallets-transactions", kwargs={"pk": wallet.id})
        response = self.client.get(url)
        # check for status 200
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # check wallet transactions
        transactions = response.data
        self.assertEqual(transactions[0]["id"], user_wallet_transaction.id)
        self.assertEqual(
            transactions[0]["internal_transaction_id"],
            user_wallet_transaction.internal_transaction_id,
        )
        self.assertEqual(
            transactions[0]["external_transaction_id"],
            user_wallet_transaction.external_transaction_id,
        )
        self.assertEqual(
            transactions[0]["transaction_type"],
            user_wallet_transaction.transaction_type,
        )
        self.assertEqual(transactions[0]["status"], user_wallet_transaction.status)
        self.assertEqual(
            transactions[0]["balance_on_transaction"],
            user_wallet_transaction.balance_on_transaction,
        )
        self.assertEqual(transactions[0]["amount"], user_wallet_transaction.amount)
        self.assertEqual(transactions[0]["source"], user_wallet_transaction.source)
        self.assertEqual(transactions[0]["destination"], user_wallet_transaction.destination)
