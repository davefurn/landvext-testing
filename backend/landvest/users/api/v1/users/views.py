from django.contrib.auth import get_user_model
from django.db import transaction
from django.utils import timezone

from rest_framework import permissions, status
from rest_framework.decorators import action
from rest_framework.parsers import JSONParser, MultiPartParser
from rest_framework.response import Response
from rest_framework.viewsets import GenericViewSet

from landvest.mixins import MultiSerializerClassMixin
from landvest.utils import get_tokens_for_user

from landvest.finance.models import Savings, Wallet
from landvest.users.api.v1.users.serializers import (
    ChangePasswordSerializer,
    CustomUserSerializer,
    ResetPasswordSerializer,
    ObtainTokenSerializer,
    ObtainTokenWithPinSerializer,
    SendSignUpOtpSerializer,
    UpdateProfileSerializer,
    UserSerializer,
    UserSignUpSerializer,
    SendResetTokenSerializer,
    SetUserTransactionPinSerializer,
    UserSignUpWithOTPSerializer,
    VerifyResetTokenSerializer,
    SendEmailVerificationTokenSerializer,
    VerifySignUpOtpSerializer,
)
from landvest.finance.api.v1.wallet.serializers import (
    UserWalletSerializer,
    UserWalletWithTransactionsSerializer,
)
from landvest.finance.api.v1.savings.serializers import UserSavingsSerializer


User = get_user_model()


class RequestViewSet(GenericViewSet):
    def get_serializer_context(self):
        context = super().get_serializer_context()
        context["request"] = self.request
        context["kwargs"] = self.kwargs
        return context


class UserViewSet(MultiSerializerClassMixin, RequestViewSet):
    queryset = User.objects.all()
    lookup_field = "pk"
    parser_classes = [MultiPartParser, JSONParser]
    serializer_class = UserSerializer
    serializer_action_classes = {
        "signup": UserSignUpSerializer,
        "signup_otp": UserSignUpWithOTPSerializer,
        "send_otp": SendSignUpOtpSerializer,
        "reset_password": ResetPasswordSerializer,
        "send_reset_token": SendResetTokenSerializer,
        "verify_reset_token": VerifyResetTokenSerializer,
        "verify_otp": VerifySignUpOtpSerializer,
        "change_password": ChangePasswordSerializer,
        "update_profile": UpdateProfileSerializer,
        "login": ObtainTokenSerializer,
        "login_with_pin": ObtainTokenWithPinSerializer,
        "me": UserSerializer,
        "wallet": UserWalletSerializer,
        "walletwithtransactions": UserWalletWithTransactionsSerializer,
        "savings": UserSavingsSerializer,
        "set_login_pin": CustomUserSerializer,
        "set_transaction_pin": SetUserTransactionPinSerializer,
    }
    permissions_action_classes = {
        "reset_password": [permissions.IsAuthenticated],
        "send_reset_token": [permissions.AllowAny],
        "send_otp": [permissions.AllowAny],
        "verify_reset_token": [permissions.AllowAny],
        "verify_otp": [permissions.AllowAny],
        "change_password": [permissions.IsAuthenticated],
        "update_profile": [permissions.IsAuthenticated],
        "me": [permissions.IsAuthenticated],
        "wallet": [permissions.IsAuthenticated],
        "walletwithtransactions": [permissions.IsAuthenticated],
        "savings": [permissions.IsAuthenticated],
        "login": [permissions.AllowAny],
        "login_with_pin": [permissions.AllowAny],
        "set_login_pin": [permissions.IsAuthenticated],
        "set_transaction_pin": [permissions.IsAuthenticated],
    }

    @action(detail=False)
    def me(self, request):
        serializer = self.get_serializer(request.user)
        return Response(status=status.HTTP_200_OK, data=serializer.data)

    @action(detail=False, methods=["post"], url_path="send-reset-token")
    def send_reset_token(self, request):
        with transaction.atomic():
            serializer = self.get_serializer(data=request.data)
            if serializer.is_valid(raise_exception=True):
                user = serializer.send()
                serializer = self.get_serializer(user)
            return Response(status=status.HTTP_200_OK, data=serializer.data)

    @action(detail=False, methods=["post"], url_path="verify-reset-token")
    def verify_reset_token(self, request):
        with transaction.atomic():
            serializer = self.get_serializer(data=request.data)
            if serializer.is_valid(raise_exception=True):
                user = serializer.verify_reset_token()
                serializer = self.get_serializer(user)
                jwt_token = get_tokens_for_user(user)
            return Response(status=status.HTTP_200_OK, data=jwt_token)

    @action(detail=False, methods=["post"], url_path="reset-password")
    def reset_password(self, request, *args, **kwargs):
        serializer = self.get_serializer(instance=request.user, data=request.data)
        if serializer.is_valid(raise_exception=True):
            serializer.save()
        response = {"detail": "Password Changed Successfully !"}
        return Response(status=status.HTTP_200_OK, data=response)

    @action(detail=False, methods=["post"], url_path="change-password")
    def change_password(self, request, *args, **kwargs):
        serializer = self.get_serializer(instance=request.user, data=request.data)
        if serializer.is_valid(raise_exception=True):
            serializer.save()
        response = {"detail": "Password Changed Successfully !"}
        return Response(status=status.HTTP_200_OK, data=response)

    @action(detail=False, methods=["post"], url_path="update-profile")
    def update_profile(self, request, *args, **kwargs):
        serializer = self.get_serializer(instance=request.user, data=request.data)
        if serializer.is_valid(raise_exception=True):
            serializer.save()
        return Response(status=status.HTTP_200_OK, data=serializer.data)

    @action(detail=False, methods=["post"])
    def login(self, request):
        with transaction.atomic():
            serializer = self.get_serializer(data=request.data)
            if serializer.is_valid(raise_exception=True):
                email = serializer.validated_data.get("email")
                password = serializer.validated_data.get("password")

                user = User.objects.filter(email=email).first()

                if user is None or not user.check_password(password):
                    return Response(
                        {"detail": "Invalid credentials"},
                        status=status.HTTP_401_UNAUTHORIZED,
                    )
                if user.is_verified is False:
                    # send otp for email verification
                    data = {"email": email}
                    verify_otp_serializer = SendSignUpOtpSerializer(
                        data=data,
                        context={"request": request},
                    )
                    # send otp
                    verify_otp_serializer.is_valid(raise_exception=True)
                    verify_otp_serializer.send()
                    return Response(
                        {"detail": "Your account has not been verified, an OTP has been sent to your email !"},
                        status=status.HTTP_401_UNAUTHORIZED,
                    )
                # # send user login verification code
                user_serializer = CustomUserSerializer(user)

                # Generate the JWT token
                jwt_token = get_tokens_for_user(user)

                return Response({"token": jwt_token, **user_serializer.data})

    @action(detail=False, methods=["post"], url_path="login-with-pin")
    def login_with_pin(self, request):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            email = serializer.validated_data.get("email")

            user = User.objects.filter(email=email).first()

            # # send user login verification code
            user_serializer = CustomUserSerializer(user)

            # Generate the JWT token
            jwt_token = get_tokens_for_user(user)

            return Response({"token": jwt_token, **user_serializer.data})

    @action(detail=False, methods=["post"], url_path="set-login-pin")
    def set_login_pin(self, request):
        with transaction.atomic():
            serializer = self.get_serializer(instance=request.user, data=request.data)
            if serializer.is_valid(raise_exception=True):
                serializer.save()
            response = {"detail": "Login Pin Set Successfully !"}
            return Response(status=status.HTTP_200_OK, data=response)

    @action(detail=False, methods=["post"], url_path="set-transaction-pin")
    def set_transaction_pin(self, request):
        with transaction.atomic():
            serializer = self.get_serializer(instance=request.user, data=request.data)
            if serializer.is_valid(raise_exception=True):
                serializer.save()
            response = {"detail": "Transaction Pin Set Successfully !"}
            return Response(status=status.HTTP_200_OK, data=response)

    @action(detail=False, methods=["post"], url_path="signup-otp")
    def signup_otp(self, request):
        data = request.data
        serializer = self.get_serializer(data=data)
        # check if account already exists
        email = data.get("email")
        user = User.objects.filter(email=email)
        if user.exists() is True:
            response = {"email": ["a user with this email already exists !"]}
            return Response(response, status=status.HTTP_200_OK)
        with transaction.atomic():
            if serializer.is_valid(raise_exception=True):
                instance = serializer.save()
                password = self.request.data.get("password")
                # create user
                instance.set_password(password)
                instance.save()
                # create users wallet
                wallet, _ = Wallet.objects.get_or_create(user=instance)
                # send email verification link
                data = {"email": instance.email}
                verify_email_serializer = SendSignUpOtpSerializer(
                    data=data,
                    context={"request": request},
                )
                verify_email_serializer.is_valid(raise_exception=True)
                user = verify_email_serializer.send()
                serializer = self.get_serializer(user)
                # serializer.is_valid(raise_exception=True)
                return Response(status=status.HTTP_201_CREATED, data=serializer.data)
        response = {}
        response["detail"] = "BAD REQUEST !"
        return Response(status=status.HTTP_400_BAD_REQUEST, data=response)

    @action(detail=False, methods=["post"], url_path="verify-otp")
    def verify_otp(self, request):
        data = request.data
        email = data.get("email")
        otp = data.get("otp")
        # find users with that email
        users = User.objects.filter(email=email, otp=otp)
        # check if token has expired
        if users.exists():
            user = users.first()
            if user.otp_expiry < timezone.now():
                response = {"otp": ["OTP has expired !"]}
                return Response(response, status=status.HTTP_403_FORBIDDEN)
        else:
            response = {"otp": ["Invalid OTP !"]}
            return Response(response, status=status.HTTP_403_FORBIDDEN)
        with transaction.atomic():
            data = request.data
            serializer = self.get_serializer(data=data)
            if serializer.is_valid(raise_exception=True):
                email = data["email"]
                user = serializer.verify_otp()
                user.is_verified = True
                user.save()
                serializer = self.get_serializer(user)
                jwt_token = get_tokens_for_user(user)
            return Response(status=status.HTTP_200_OK, data=jwt_token)

    @action(detail=False, methods=["post"], url_path="send-otp")
    def send_otp(self, request):
        data = request.data
        email = data["email"]
        if email:
            # check if account has already been verified
            users = User.objects.filter(email=email, is_verified=True)
            if users.exists() is True:
                response = {"email": ["You account has already been verified !"]}
                return Response(response, status=status.HTTP_200_OK)

        with transaction.atomic():
            serializer = self.get_serializer(data=request.data)
            if serializer.is_valid(raise_exception=True):
                user = serializer.send()
                serializer = self.get_serializer(user)
            return Response(status=status.HTTP_200_OK, data=serializer.data)

    @action(detail=False, methods=["post"])
    def signup(self, request):
        serializer = self.get_serializer(data=request.data)
        with transaction.atomic():
            if serializer.is_valid(raise_exception=True):
                instance = serializer.save()
                password = self.request.data.get("password")
                # create user
                instance.set_password(password)
                instance.save()
                # create users wallet
                wallet, _ = Wallet.objects.get_or_create(user=instance)
                # send email verification link
                data = {"email": instance.email}
                verify_email_serializer = SendEmailVerificationTokenSerializer(
                    data=data,
                    context={"request": request},
                )
                verify_email_serializer.is_valid(raise_exception=True)
                verify_email_serializer.send()
                return Response(status=status.HTTP_201_CREATED, data=serializer.data)
        response = {}
        response["detail"] = "BAD REQUEST !"
        return Response(status=status.HTTP_400_BAD_REQUEST, data=response)

    @action(detail=False, methods=["get"])
    def wallet(self, request, *args, **kwargs):
        try:
            with transaction.atomic():
                user = self.request.user
                # get user's wallet
                wallet_ = Wallet.objects.select_related("user").get(user=user)
                serializer = self.get_serializer(wallet_, many=False)
                return Response(status=status.HTTP_200_OK, data=serializer.data)
        except:
            return Response(status=status.HTTP_404_NOT_FOUND)

    @action(detail=False, methods=["get"], url_path="wallet-withtransactions")
    def walletwithtransactions(self, request, *args, **kwargs):
        try:
            with transaction.atomic():
                user = self.request.user
                # get user's wallet
                wallet_ = Wallet.objects.select_related("user").get(user=user)
                serializer = self.get_serializer(wallet_, many=False)
                return Response(status=status.HTTP_200_OK, data=serializer.data)
        except:
            return Response(status=status.HTTP_404_NOT_FOUND)

    @action(detail=False, methods=["get"])
    def savings(self, request, *args, **kwargs):
        try:
            with transaction.atomic():
                user = self.request.user
                # get user's savings_
                savings_ = Savings.objects.select_related("user").filter(user=user)
                serializer = self.get_serializer(savings_, many=True)
                return Response(status=status.HTTP_200_OK, data=serializer.data)
        except:
            return Response(status=status.HTTP_404_NOT_FOUND)
