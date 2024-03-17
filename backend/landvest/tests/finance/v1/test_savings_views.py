from django.utils import timezone
from datetime import timedelta
from django.urls import reverse
from rest_framework import status
from landvest.utils import generate_numbers_token, get_percentage_of_amount
from landvest.finance.models import (
    Savings,
    SavingsTransaction,
    Wallet,
    WalletTransaction,
)
from landvest.tests.globals.v1 import GlobalAPITestCase

# serializers

# models


class SavingsViewSetAPITestCase(GlobalAPITestCase):
    def setUp(self) -> None:
        self.url = reverse("api:v1:savings-list")
        self.transactions_url = reverse("api:v1:savings-transactions", kwargs={"pk": 2})
        self.assertEqual(self.url, "/api/v1/savings/")

        return super().setUp()    

    def test_creatingSavings_shouldBeSuccessful(self):
        # authenticate user
        self.client.force_authenticate(self.auth_user)
        # test for successful creation of savings
        data = {
            "title": "School Fees",
            "target": 100000,
            "withdrawal_date": timezone.now() + timedelta(weeks=52),
        }
        url = self.url
        response = self.client.post(path=url, data=data, format="json")
        # check for 201 status code
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data["title"], "School Fees")
        self.assertEqual(response.data["target"], 100000)

    def create_savings(self, user):
        # create and return savings
        savings = Savings.objects.create(
        title = "School Fees",
        target = 100000,
        user=user,
        withdrawal_date = timezone.now() + timedelta(weeks=52),
        )
        return savings

    def test_updatingSingleSavings_shouldBeSuccessful(self):
        # authenticate user
        self.client.force_authenticate(self.auth_user)
        # get created savings
        savings = self.create_savings(self.auth_user)
        # check update
        data = {"title": "Lodge Rent Money ray"}
        url = f"{self.url}{savings.id}/"
        response = self.client.put(path=url, data=data, format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["title"], data["title"])
        self.assertNotEqual(response.data["title"], savings.title)

    def test_updatingTargetOfAParticularSavings_shouldNotUpdateTarget(self):
        # authenticate user
        self.client.force_authenticate(self.auth_user)
        # get created savings
        savings = self.create_savings(self.auth_user)
        # check update
        data = {"title": "Lodge Rent Money ray", "target": 20}
        url = f"{self.url}{savings.id}/"
        response = self.client.put(path=url, data=data, format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["title"], data["title"])
        self.assertNotEqual(response.data["title"], savings.title)
        self.assertEqual(response.data['target'], savings.target)
        self.assertNotEqual(response.data['target'], data['target'])

    def test_tryingToUpdateAnotherUsersSavings_shouldNotBeSuccessful(self):
        # authenticate user
        self.client.force_authenticate(self.user)
        # get created savings
        savings = self.create_savings(self.auth_user)
        data = {"title": "Lodge Rent Money ray"}
        url = f"{self.url}{savings.id}/"
        response = self.client.put(path=url, data=data, format="json")
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, "this savings doesn't belong to you !")
    
    def create_user_savings_transaction(self, savings):
        amount = 434
        balance_on_transaction = 1200
        internal_transaction_id = generate_numbers_token(count=16)
        external_transaction_id = generate_numbers_token(count=16)
        user_savings_transaction = SavingsTransaction.objects.create(
            savings=savings,
            transaction_type="CREDIT",
            internal_transaction_id=internal_transaction_id,
            external_transaction_id=external_transaction_id,
            amount=amount,
            balance_on_transaction=balance_on_transaction,
        )
        return user_savings_transaction

    def create_user_wallet(self, user):
        # get user wallet
        wallet,created = Wallet.objects.get_or_create(user=user)
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

    def test_fetchingTransactions_shouldBeSuccessful(self):
        # authenticate user
        self.client.force_authenticate(self.auth_user)
        # get created savings
        savings = self.create_savings(self.auth_user)
        savings_transaction = self.create_user_savings_transaction(savings)

        url = reverse("api:v1:savings-transactions", kwargs={"pk": savings.id})
        response = self.client.get(url)
        # check for status 200
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # check savings transactions
        transactions = response.data
        self.assertEqual(transactions[0]["id"], savings_transaction.id)
        self.assertEqual(
            transactions[0]["internal_transaction_id"],
            savings_transaction.internal_transaction_id,
        )
        self.assertEqual(
            transactions[0]["external_transaction_id"],
            savings_transaction.external_transaction_id,
        )
        self.assertEqual(
            transactions[0]["transaction_type"],
            savings_transaction.transaction_type,
        )
        self.assertEqual(transactions[0]["status"], savings_transaction.status)
        self.assertEqual(
            transactions[0]["balance_on_transaction"],
            savings_transaction.balance_on_transaction,
        )
        self.assertEqual(transactions[0]["amount"], savings_transaction.amount)
        self.assertEqual(transactions[0]["source"], savings_transaction.source)
        self.assertEqual(
            transactions[0]["destination"], savings_transaction.destination
        )

    def test_withdrawalFromEmptySavingsToWallet_shouldNotBeSuccessful(self):
        savings = self.create_savings(self.auth_user)
        wallet  = self.create_user_wallet(self.auth_user)
        # authenticate user
        self.client.force_authenticate(self.auth_user)
        response = self.client.post(reverse('api:v1:savings-withdrawal-to-wallet', kwargs={'pk':savings.pk}))
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, "This savings is empty !")

    def test_withdrawalFromAnotherUserSavingsToWallet_shouldNotBeSuccessful(self):
        savings = self.create_savings(self.auth_user)
        # authenticate user
        self.client.force_authenticate(self.user)
        response = self.client.post(reverse('api:v1:savings-withdrawal-to-wallet', kwargs={'pk':savings.pk}))
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, "this savings doesn't belong to you !")

    def test_withdrawalFromSavingsToWalletWithoutHavingWallet_shouldNotBeSuccessful(self):
        savings = self.create_savings(self.auth_user)
        # authenticate user
        self.client.force_authenticate(self.auth_user)
        # topup savings
        savings_transactions = self.create_user_savings_transaction(savings)
        response = self.client.post(reverse('api:v1:savings-withdrawal-to-wallet', kwargs={'pk':savings.pk}))
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, {"message": "You don't have a wallet !"})

    def test_withdrawalFromNonEmptySavingsToWalletWithWalletBeforeWithdrawalDate_shouldBeSuccessful(self):
        savings = self.create_savings(self.auth_user)
        # change withdrawal date to the future
        savings.withdrawal_date = timezone.now() + timedelta(days=2)
        savings.save()
        wallet  = self.create_user_wallet(self.auth_user)
        # authenticate user
        self.client.force_authenticate(self.auth_user)
        # topup savings
        savings_transactions = self.create_user_savings_transaction(savings)
        savings_transactions.status = "SUCCESS"
        savings_transactions.save()
        # try to withdraw to wallet
        response = self.client.post(reverse('api:v1:savings-withdrawal-to-wallet', kwargs={'pk':savings.pk}))
        print('savings.current_balance', savings.current_balance)
        print('response.data', response.data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data, "Withdrawal Was Successful !")
        # confirm that savings is empty
        self.assertEqual(savings.current_balance, 0)
        # confirm that wallet was topped up
        get_last_wallet_transaction = WalletTransaction.objects.last()
        amount_to_be_deposited_to_wallet = get_percentage_of_amount(90, savings_transactions.amount)
        self.assertEqual(get_last_wallet_transaction.amount, amount_to_be_deposited_to_wallet)

    def test_withdrawalFromNonEmptySavingsToWalletWithWalletAfterWithdrawalDate_shouldBeSuccessful(self):
        savings = self.create_savings(self.auth_user)
        # change withdrawal date to the future
        savings.withdrawal_date = timezone.now() + timedelta(days=2)
        savings.save()
        wallet  = self.create_user_wallet(self.auth_user)
        # authenticate user
        self.client.force_authenticate(self.auth_user)
        # topup savings
        savings_transactions = self.create_user_savings_transaction(savings)
        savings_transactions.status = "SUCCESS"
        savings_transactions.save()
        # try to withdraw to wallet
        response = self.client.post(reverse('api:v1:savings-withdrawal-to-wallet', kwargs={'pk':savings.pk}))
        print('savings.current_balance', savings.current_balance)
        print('response.data', response.data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data, "Withdrawal Was Successful !")
        # confirm that savings is empty
        self.assertEqual(savings.current_balance, 0)
        # confirm that wallet was topped up
        get_last_wallet_transaction = WalletTransaction.objects.last()
        amount_to_be_deposited_to_wallet = get_percentage_of_amount(90, savings_transactions.amount)
        self.assertEqual(get_last_wallet_transaction.amount, amount_to_be_deposited_to_wallet)

    def test_topupAnotherUserSavingsFromWallet_shouldNotBeSuccessful(self):
        savings = self.create_savings(self.auth_user)
        # authenticate user
        self.client.force_authenticate(self.user)
        response = self.client.post(reverse('api:v1:savings-topup-from-wallet', kwargs={'pk':savings.pk}))
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, "this savings doesn't belong to you !")

    def test_topupSavingsFromWalletWithoutHavingWallet_shouldNotBeSuccessful(self):
        savings = self.create_savings(self.auth_user)
        # authenticate user
        self.client.force_authenticate(self.auth_user)
        response = self.client.post(reverse('api:v1:savings-topup-from-wallet', kwargs={'pk':savings.pk}))
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, {"message": "You don't have a wallet !"})

    def test_topupSavingsFromEmptyWallet_shouldNotBeSuccessful(self):
        savings = self.create_savings(self.auth_user)
        # authenticate user
        self.client.force_authenticate(self.auth_user)
        # create wallet
        wallet  = self.create_user_wallet(self.auth_user)
        response = self.client.post(reverse('api:v1:savings-topup-from-wallet', kwargs={'pk':savings.pk}))
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, "Your wallet is empty !")

    def test_topupSavingsFromWalletWhenAmountToDepositedIsMoreThanWalletBalance_shouldNotBeSuccessful(self):
        savings = self.create_savings(self.auth_user)
        # authenticate user
        self.client.force_authenticate(self.auth_user)
        # create wallet
        wallet  = self.create_user_wallet(self.auth_user)
        # topup wallet with 1000
        wtransaction = self.create_user_wallet_transaction(wallet)
        wtransaction.status = 'SUCCESS'
        wtransaction.amount = 1000
        wtransaction.save()
        # try to withdraw 1000.01
        data = {'amount':1000.01}
        response = self.client.post(reverse('api:v1:savings-topup-from-wallet', kwargs={'pk':savings.pk}), data=data, format="json")
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, "Insufficient Funds !")

    def test_topupSavingsFromWallet_shouldBeSuccessful(self):
        savings = self.create_savings(self.auth_user)
        # authenticate user
        self.client.force_authenticate(self.auth_user)
        # create wallet
        wallet  = self.create_user_wallet(self.auth_user)
        # topup wallet with 1000
        wtransaction = self.create_user_wallet_transaction(wallet)
        wtransaction.status = 'SUCCESS'
        wtransaction.amount = 1000
        wtransaction.save()
        # try to withdraw 1000
        data = {'amount':1000}
        response = self.client.post(reverse('api:v1:savings-topup-from-wallet', kwargs={'pk':savings.pk}), data=data, format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data, "Topup Was Successful !")
        # check if wallet is empty
        self.assertEqual(wallet.current_balance, 0)
        # check if savings was topped up
        self.assertEqual(savings.current_balance, 1000)
