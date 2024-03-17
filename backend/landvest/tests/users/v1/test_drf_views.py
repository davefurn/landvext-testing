from django.utils import timezone
from datetime import timedelta
from django.urls import reverse
from rest_framework import status
from landvest.utils import generate_numbers_token

# serializers

# models
from landvest.users.models import User
from landvest.tests.globals.v1 import GlobalAPITestCase
from landvest.finance.models import Savings, Wallet, WalletTransaction


class UserViewSetAPITestCase(GlobalAPITestCase):
    def setUp(self):
        # endpoints
        self.login_url = reverse("api:v1:users-login")
        self.signup_url = reverse("api:v1:users-signup")
        self.signup_otp_url = reverse("api:v1:users-signup-otp")
        self.reset_password_url = reverse("api:v1:users-reset-password")
        self.send_reset_token_url = reverse("api:v1:users-send-reset-token")
        self.verify_reset_token_url = reverse("api:v1:users-verify-reset-token")
        self.verify_otp_url = reverse("api:v1:users-verify-otp")
        self.change_password_url = reverse("api:v1:users-change-password")
        self.update_profile_url = reverse("api:v1:users-update-profile")
        self.login_with_pin_url = reverse("api:v1:users-login-with-pin")
        self.wallet_url = reverse("api:v1:users-wallet")
        self.walletwithtransactions_url = reverse("api:v1:users-walletwithtransactions")
        self.savings_url = reverse("api:v1:users-savings")
        self.set_login_pin_url = reverse("api:v1:users-set-login-pin")
        self.set_transaction_pin_url = reverse("api:v1:users-set-transaction-pin")
        # endpoints
        return super().setUp()

    def test_login_shouldBeSuccessful(self):
        data = {
            "email": self.verified_email,
            "password": self.verified_password,
        }
        url = self.login_url
        self.assertEqual(url, "/api/v1/users/login/")
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # check response data
        self.assertIn("token", response.data)
        self.assertEqual(response.data["email"], self.verified_email)
        self.assertEqual(response.data["phone_number"], self.verified_phone_number)
        self.assertEqual(response.data["first_name"], self.verified_first_name)
        self.assertEqual(response.data["last_name"], self.verified_last_name)

    def test_unverifiedLogin_shouldNotBeSuccessful(self):
        data = {
            "email": self.email,
            "password": self.password,
        }
        url = self.login_url
        response_data = {"detail": "Your account has not been verified, an OTP has been sent to your email !"}
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
        self.assertEqual(response.data, response_data)

    def test_loginWithPin_shouldBeSuccessful(self):
        data = {
            "email": self.verified_email,
            "login_pin": self.verified_login_pin,
        }
        url = self.login_with_pin_url
        self.assertEqual(url, "/api/v1/users/login-with-pin/")
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # check response data
        self.assertIn("token", response.data)
        self.assertEqual(response.data["email"], self.verified_email)
        self.assertEqual(response.data["phone_number"], self.verified_phone_number)
        self.assertEqual(response.data["first_name"], self.verified_first_name)
        self.assertEqual(response.data["last_name"], self.verified_last_name)

    def test_loginWithWrongPin_shouldNotBeSuccessful(self):
        # test wrong pin
        data = {
            "email": self.verified_email,
            "login_pin": 00,
        }
        response_data = {"login_pin": ["Invalid Login Pin !"]}
        response = self.client.post(self.login_with_pin_url, data)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertEqual(response.data, response_data)

    def test_unverifiedLoginWithPin_shouldNotBeSuccessful(self):
        data = {
            "email": self.email,
            "login_pin": self.login_pin,
        }
        response_data = {"non_field_errors": ["A verification link has been sent to your email !"]}
        response = self.client.post(self.login_with_pin_url, data)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertEqual(response.data, response_data)

    def test_signup_shouldBeSuccessful(self):
        data = {
            "email": "izuchukwu2@gmail.com",
            "first_name": "Emmanuel",
            "last_name": "Django",
            "password": "09155202857",
            "phone_number": "29155202859",
        }
        self.assertEqual(self.signup_url, "/api/v1/users/signup/")
        valid_response = {
            "email": "izuchukwu2@gmail.com",
            "phone_number": "29155202859",
            "first_name": "Emmanuel",
            "last_name": "Django",
        }
        response = self.client.post(self.signup_url, data)
        # check if the status code is 201
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        # check if it returned the right data
        self.assertEqual(response.data, valid_response)

    def test_emailAlreadyExistsDuringSignup_shouldNotBeSuccessful(self):
        data = {
            "email": self.email,
            "first_name": "Emmanuel",
            "last_name": "Django",
            "password": "09155202857",
            "phone_number": "29155202859",
        }
        # test for already exists
        invalid_response = {
            "email": [
                "user with this Email Address already exists."
            ]
        }
        response = self.client.post(self.signup_url, data)
        # check if the status code is 400
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        # check if it returned the right data
        self.assertEqual(response.data, invalid_response)

    def test_fieldRequiredDuringSignup_shouldNotBeSuccessful(self):
        email = f"valid{self.email}"
        password = self.password
        data = {
            "email": email,
            "password": password,
        }
        url = self.signup_url
        response = self.client.post(url, data)
        # invalid response
        invalid_response = {"phone_number": ["This field is required."]}
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        # check response data
        self.assertEqual(response.data, invalid_response)

    def test_signupWithOtp_shouldBeSuccessful(self):
        data = {
            "email": "izuchukwu2@gmail.com",
            "first_name": "Emmanuel",
            "last_name": "Django",
            "password": "09155202857",
            "phone_number": "29155202859",
        }
        response = self.client.post(self.signup_otp_url, data)
        # check if the status code is 201
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        # fetch user
        user = User.objects.get(email="izuchukwu2@gmail.com")
        valid_response = {
            "email": user.email,
            "phone_number": user.phone_number,
            "first_name": user.first_name,
            "last_name": user.last_name,
            "otp": user.otp,
        }
        # check if it returned the right data
        self.assertEqual(response.data, valid_response)

    def test_emailAlreadyExistsDuringSignupWithOtp_shouldBeSuccessful(self):
        data = {
            "email": self.email,
            "first_name": "Emmanuel",
            "last_name": "Django",
            "password": "09155202857",
            "phone_number": "29155202859",
        }
        # test for already exists
        invalid_response = {
            "email": ["a user with this email already exists !"],
            # "phone_number": ["user with this Phone Number already exists."],
        }
        response = self.client.post(self.signup_otp_url, data)
        # check if the status code is 400
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # check if it returned the right data
        self.assertEqual(response.data, invalid_response)

    def test_verifyOtp_shouldBeSuccessful(self):
        email = "izuchukwu2@gmail.com"
        first_name = "Emmanuel"
        last_name = "Django"
        password = "09155202857"
        phone_number = "29155202859"
        data = {
            "email": email,
            "first_name": first_name,
            "last_name": last_name,
            "password": password,
            "phone_number": phone_number,
        }
        url = self.signup_otp_url
        response = self.client.post(url, data)
        # check if the status code is 201
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        # fetch user
        user = User.objects.get(email=email)
        response_data = {
            "email": email,
            "phone_number": phone_number,
            "first_name": first_name,
            "last_name": last_name,
            "otp": user.otp,
        }
        # check if it returned the right data
        self.assertEqual(response.data, response_data)

    def test_invalidOtpDuringVerification_shouldBeSuccessful(self):
        # test for invalid otp
        valid_data = {"email": "izuchukwu2@gmail.com", "otp": "000"}
        response = self.client.post(self.verify_otp_url, valid_data)
        # check if it says invalid otp
        response_data = {"otp": ["Invalid OTP !"]}
        self.assertEqual(response.data, response_data)
        # check if status code is 400
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_validOtpDuringVerification_shouldBeSuccessful(self):
        # get user_otp
        otp = 9656
        user = User.objects.get(email=self.email)
        user.otp = otp
        user.otp_expiry = timezone.now() + timedelta(weeks=52)
        user.save()
        valid_data = {"email": self.email, "otp": otp}
        response = self.client.post(self.verify_otp_url, valid_data)
        # check if access and refresh tokens exists
        self.assertIn("access", response.data)
        self.assertIn("refresh", response.data)
        # check if status code is 200
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_wrongCurrentPaaswordDuringChangePassword_shouldNotBeSuccessful(self):
        self.assertEqual(self.change_password_url, "/api/v1/users/change-password/")
        # authenticate user
        self.client.force_authenticate(self.auth_user)
        data = {
            "current_password": "wrong password",
            "new_password": "091552028571",
            "confirm_password": "091552028571",
        }
        response = self.client.post(self.change_password_url, data)
        response_data = {"current_password": ["Current Password is wrong !"]}
        # check for error response data
        self.assertEqual(response.data, response_data)
        # check for status 400
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_correctCurrentPaaswordDuringChangePassword_shouldNotBeSuccessful(self):
        # authenticate user
        self.client.force_authenticate(self.auth_user)
        # test for valid request data
        data = {
            "current_password": self.auth_password,
            "new_password": "091552028571",
            "confirm_password": "091552028571",
        }
        response = self.client.post(self.change_password_url, data)
        response_data = {"detail": "Password Changed Successfully !"}
        # check for status 200
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # check for response data
        self.assertEqual(response.data, response_data)

    def test_updatingProfileWithoutToken_shouldNotBeSuccessful(self):
        data = {
            "first_name": "Emma",
            "last_name": "Izuchukwu",
            "phone_number": "+2349155202857",
            "location": "Alaba International",
        }
        invalid_response = {"detail": "Authentication credentials were not provided."}
        self.assertEqual(self.update_profile_url, "/api/v1/users/update-profile/")
        response = self.client.post(self.update_profile_url, data)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
        self.assertEqual(response.data, invalid_response)

    def test_updatingProfileWithToken_shouldBeSuccessful(self):
        self.client.force_authenticate(self.auth_user)
        # get token for user
        data = {
            "first_name": "Emma",
            "last_name": "Izuchukwu",
            "phone_number": "+2349155202857",
            "location": "Alaba International",
        }
        valid_response = {
            "first_name": "Emma",
            "last_name": "Izuchukwu",
            "phone_number": "+2349155202857",
            "location": "Alaba International",
            "image": None,
        }
        self.assertEqual(self.update_profile_url, "/api/v1/users/update-profile/")
        response = self.client.post(self.update_profile_url, data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data, valid_response)

    def test_updatingProfileWithEmptyData_shouldNotBeSuccessful(self):
        self.client.force_authenticate(self.auth_user)
        # get token for user
        data = {}
        self.assertEqual(self.update_profile_url, "/api/v1/users/update-profile/")
        response = self.client.post(self.update_profile_url, data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_resettingPassword_shouldBeSuccessful(self):
        self.client.force_authenticate(self.auth_user)
        self.assertEqual(self.reset_password_url, "/api/v1/users/reset-password/")
        data = {"password": "091552028571", "confirm_password": "091552028571"}
        response_data = {"detail": "Password Changed Successfully !"}
        self.client.force_authenticate(self.auth_user)
        response = self.client.post(self.reset_password_url, data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data, response_data)
        self.assertIn("detail", response.data)

    def test_whenPasswordIsNotEqualToConfirmPassword_shouldNotBeSuccessful(self):
        self.client.force_authenticate(self.auth_user)
        # test for password not equal confirm_password
        data = {"password": "091552028571", "confirm_password": "091552028570"}
        response_data = {"password": ["Password and Confirm Password Don't Match !"]}
        response = self.client.post(self.reset_password_url, data)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertEqual(response.data, response_data)
        self.assertIn("password", response.data)

    def test_resettingPasswordWithoutConfirmPassword_shouldNotBeSuccessful(self):
        self.client.force_authenticate(self.auth_user)
        # test for required fields
        data = {"password": "091552028571"}
        response_data = {"confirm_password": ["This field is required."]}
        response = self.client.post(self.reset_password_url, data)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertEqual(response.data, response_data)
        self.assertIn("confirm_password", response.data)

    def test_sendingResetTokenWithEmailThatDoNotExist_shouldNotBeSuccessful(self):
        self.assertEqual(self.send_reset_token_url, "/api/v1/users/send-reset-token/")
        # test for email that doesn't exist in database
        data = {"email": "dontexists@gmail.com"}
        response_data = {"email": ["Invalid Email !"]}
        response = self.client.post(self.send_reset_token_url, data)
        # check for status 400
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        # check for error response data
        self.assertEqual(response.data, response_data)

    def test_sendingResetTokenWithEmailThatExists_shouldBeSuccessful(self):
        # test with valid email
        data = {"email": self.email}
        response = self.client.post(self.send_reset_token_url, data)
        password_reset_token = response.data["password_reset_token"]
        # check for status 200
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # check for valid response data
        self.assertIn("password_reset_token", response.data)
        self.assertEqual(response.data["password_reset_token"], password_reset_token)

    def test_verifyingResetToken_shouldBeSuccessful(self):
        self.assertEqual(self.verify_reset_token_url, "/api/v1/users/verify-reset-token/")
        # test with valid email
        data = {"email": self.email}
        response = self.client.post(self.send_reset_token_url, data)
        # check for status 200
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # check for valid response data
        self.assertIn("password_reset_token", response.data)

    def test_verifyingResetTokenWithInvalidResetToken_shouldNotBeSuccessful(self):
        # test for invalid reset token
        data = {"email": self.email, "password_reset_token": 937}
        response_data = {"password_reset_token": ["Invalid Reset Token !"]}
        response = self.client.post(self.verify_reset_token_url, data)
        # check the error response data
        self.assertEqual(response.data, response_data)
        # check for status 400
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_verifyingResetTokenWithValidResetToken_shouldBeSuccessful(self):
        password_reset_token = 9656
        user = User.objects.get(email=self.email)
        user.password_reset_token = password_reset_token
        user.password_reset_token_expiry = timezone.now() + timedelta(weeks=52)
        user.save()
        # test for valid reset token
        data = {"email": self.email, "password_reset_token": password_reset_token}
        response = self.client.post(self.verify_reset_token_url, data)
        # check the error response data
        self.assertIn("refresh", response.data)
        self.assertIn("access", response.data)
        # check for status 200
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_walletGetsCReatedAfterSignup_shouldBeSuccessful(self):
        data = {
            "email": "izuchukwu2@gmail.com",
            "first_name": "Emmanuel",
            "last_name": "Django",
            "password": "09155202857",
            "phone_number": "29155202859",
        }
        self.assertEqual(self.signup_url, "/api/v1/users/signup/")
        valid_response = {
            "email": "izuchukwu2@gmail.com",
            "phone_number": "29155202859",
            "first_name": "Emmanuel",
            "last_name": "Django",
        }
        response = self.client.post(self.signup_url, data)
        # check if the status code is 201
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        # check if it returned the right data
        self.assertEqual(response.data, valid_response)
        # get created user
        user = User.objects.get(email="izuchukwu2@gmail.com")

        self.client.force_authenticate(user)
        response = self.client.get(self.wallet_url)
        # check for status 200
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # check for created wallet
        user_wallet = Wallet.objects.get(user=user)
        self.assertEqual(response.data["id"], user_wallet.id)
        self.assertEqual(response.data["current_balance"], user_wallet.current_balance)

    def test_fetchingWalletWithTransactions_shouldBeSuccessful(self):
        data = {
            "email": "izuchukwu2@gmail.com",
            "first_name": "Emmanuel",
            "last_name": "Django",
            "password": "09155202857",
            "phone_number": "29155202859",
        }

        valid_response = {
            "email": "izuchukwu2@gmail.com",
            "phone_number": "29155202859",
            "first_name": "Emmanuel",
            "last_name": "Django",
        }
        response = self.client.post(self.signup_url, data)
        # check if the status code is 201
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        # check if it returned the right data
        self.assertEqual(response.data, valid_response)
        # get created user
        user = User.objects.get(email="izuchukwu2@gmail.com")
        # create walletwithtransactions
        user_wallet = Wallet.objects.get(user=user)
        amount = 434
        balance_on_transaction = 1200
        internal_transaction_id = generate_numbers_token(count=16)
        external_transaction_id = generate_numbers_token(count=16)
        user_wallet_transaction = WalletTransaction.objects.create(
            wallet=user_wallet,
            transaction_type="CREDIT",
            internal_transaction_id=internal_transaction_id,
            external_transaction_id=external_transaction_id,
            amount=amount,
            balance_on_transaction=balance_on_transaction,
        )

        self.client.force_authenticate(user)
        response = self.client.get(self.walletwithtransactions_url)
        # check for status 200
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # check for created wallet
        self.assertEqual(response.data["id"], user_wallet.id)
        self.assertEqual(response.data["current_balance"], user_wallet.current_balance)
        # check wallet transactions
        transactions = response.data["transactions"]
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

    def test_creatingSavings_shouldBeSuccessful(self):
        self.client.force_authenticate(self.user)
        response = self.client.get(self.savings_url)
        self.assertEqual(response.data, [])
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # create savings
        title = "savings for rent"
        user = self.user
        withdrawal_date = timezone.now() + timedelta(weeks=52)
        target = 5000
        user_saving = Savings.objects.create(
            title=title,
            user=user,
            withdrawal_date=withdrawal_date,
            target=target,
        )
        response = self.client.get(self.savings_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data[0]["id"], user_saving.id)
        self.assertEqual(response.data[0]["title"], title)
        self.assertEqual(response.data[0]["target"], target)
        self.assertEqual(response.data[0]["current_balance"], user_saving.current_balance)

    def test_settingLoginPin_shouldBeSuccessful(self):
        self.client.force_authenticate(self.user)
        data = {"login_pin": "249845"}
        response = self.client.post(self.set_login_pin_url, data)
        response_data = {"detail": "Login Pin Set Successfully !"}
        self.assertEqual(response.data, response_data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # cross check login_pin with database
        self.assertEqual(self.user.login_pin, data["login_pin"])

    def test_setttingTransactionPin_shouldBeSuccessful(self):
        self.client.force_authenticate(self.user)
        data = {"transaction_pin": "249445"}
        response = self.client.post(self.set_transaction_pin_url, data)
        response_data = {"detail": "Transaction Pin Set Successfully !"}
        self.assertEqual(response.data, response_data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # cross check transaction_pin with database
        self.assertEqual(self.user.transaction_pin, data["transaction_pin"])
