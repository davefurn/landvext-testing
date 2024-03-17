from django.contrib.auth import get_user_model
from django.core.mail import send_mail
from django.db import transaction
from django.utils import timezone
from datetime import timedelta
from django.template.loader import render_to_string
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode

from landvest.users.models import User as UserType
from landvest.utils import generate_numbers_token, account_activation_token, get_origin

from rest_framework import serializers

User = get_user_model()

base_user_fields = [
    "email",
    "phone_number",
]

base_extra_kwargs = {
    "date_created": {"read_only": True},
    "date_modified": {"read_only": True},
    "id": {"read_only": True},
}


class UserSerializer(serializers.ModelSerializer[UserType]):
    class Meta:
        model = User
        fields = [
            *base_user_fields,
            "first_name",
            "last_name",
            "username",
        ]


class SendEmailVerificationTokenSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(write_only=True, required=True)

    class Meta:
        model = User
        fields = [
            "email",
        ]

    def validate_email(self, value):
        if not value:
            raise serializers.ValidationError("Email is required !")
        user = User.objects.filter(email=value)
        if not user.exists():
            raise serializers.ValidationError("Invalid Email !")
        return value

    def send(self, **kwargs):
        with transaction.atomic():
            request = self.context["request"]
            user_email = self.validated_data["email"]
            user = User.objects.only("email").get(email=user_email)
            # send token to email
            template = "email/email_verification.html"
            subject = "LandVest: Verify Email"
            message = render_to_string(
                template,
                {
                    "request": request,
                    "user": user,
                    "origin": get_origin(request),
                    "uid": urlsafe_base64_encode(force_bytes(user.pk)),
                    "token": account_activation_token.make_token(user),
                },
            )
            send_mail(
                subject,
                from_email="landvest <noreply@emmadjango.tech>",
                recipient_list=[user_email],
                fail_silently=False,
                html_message=message,
                message="",
            )
            return user
        return None


class SendResetTokenSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(write_only=True, required=True)

    class Meta:
        model = User
        fields = [
            "email",
            "password_reset_token",
        ]
        extra_kwargs = {
            "password_reset_token": {"read_only": True},
        }

    def validate_email(self, value):
        if not value:
            raise serializers.ValidationError("Email is required !")
        user = User.objects.filter(email=value)
        if not user.exists():
            raise serializers.ValidationError("Invalid Email !")
        return value

    def send(self, **kwargs):
        with transaction.atomic():
            user_email = self.validated_data["email"]
            user = User.objects.get(email=user_email)
            user.password_reset_token = generate_numbers_token(4)
            # password_reset_token_expiry should expire in 5 minutes
            user.password_reset_token_expiry = timezone.now() + timedelta(minutes=5)
            user.save()
            # send token to email
            subject = "LandVest: Password Reset Token"
            message = f"Your Password Reset Token is: {user.password_reset_token}"
            send_mail(
                subject,
                message,
                "landvest <noreply@emmadjango.tech>",
                [user_email],
                fail_silently=False,
            )
            return user
        return None


class VerifyResetTokenSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(write_only=True, required=True)

    class Meta:
        model = User
        fields = [
            "email",
            "password_reset_token",
        ]
        extra_kwargs = {"password_reset_token": {"required": True}}

    def validate_email(self, value):
        if not value:
            raise serializers.ValidationError("Email is required !")
        user = User.objects.filter(email=value)
        if not user.exists():
            raise serializers.ValidationError("Invalid Email !")
        return value

    def validate_password_reset_token(self, value):
        if not value:
            raise serializers.ValidationError("Password Reset Token is required !")
        email = self.context["request"].data["email"]
        user = User.objects.filter(password_reset_token=value, email=email)
        # check if token has expired
        if user.exists():
            user = user.first()
            if user.password_reset_token_expiry < timezone.now():
                raise serializers.ValidationError("Password Reset Token has expired !")
        else:
            raise serializers.ValidationError("Invalid Reset Token !")
        return value

    def verify_reset_token(self, **kwargs):
        user_email = self.validated_data["email"]
        user = User.objects.get(email=user_email)
        return user


class SendSignUpOtpSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(write_only=True, required=True)

    class Meta:
        model = User
        fields = [
            "email",
            "otp",
        ]
        extra_kwargs = {
            "otp": {"read_only": True},
        }

    def validate_email(self, value):
        if not value:
            raise serializers.ValidationError("Email is required !")
        user = User.objects.filter(email=value)
        if not user.exists():
            raise serializers.ValidationError("Invalid Email !")
        if user.first().is_verified is True:
            raise serializers.ValidationError("You account has already been verified !")
        return value

    def send(self, **kwargs):
        with transaction.atomic():
            user_email = self.validated_data["email"]
            user = User.objects.get(email=user_email)
            user.otp = generate_numbers_token(4)
            # otp_expiry should expire in 5 minutes
            user.otp_expiry = timezone.now() + timedelta(minutes=5)
            user.save()
            # send token to email
            subject = "LandVest: SignUp OTP"
            message = f"Your OTP is: {user.otp}"
            send_mail(
                subject,
                message,
                "landvest <noreply@emmadjango.tech>",
                [user_email],
                fail_silently=False,
            )
            return user
        return None


class VerifySignUpOtpSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(write_only=True, required=True)

    class Meta:
        model = User
        fields = [
            "email",
            "otp",
        ]
        extra_kwargs = {"otp": {"required": True}}

    def validate_email(self, value):
        if not value:
            raise serializers.ValidationError("Email is required !")
        user = User.objects.filter(email=value)
        if not user.exists():
            raise serializers.ValidationError("Invalid Email !")
        return value

    def validate_otp(self, value):
        if not value:
            raise serializers.ValidationError("OTP is required !")
        email = self.context["request"].data["email"]
        user = User.objects.filter(otp=value, email=email)
        # check if token has expired
        if user.exists():
            user = user.first()
            if user.otp_expiry < timezone.now():
                raise serializers.ValidationError("OTP has expired !")
        else:
            raise serializers.ValidationError("Invalid OTP !")
        return value

    def verify_otp(self, **kwargs):
        user_email = self.validated_data["email"]
        user = User.objects.get(email=user_email)
        return user


class UserSignUpSerializer(serializers.ModelSerializer[UserType]):
    password = serializers.CharField(max_length=200, write_only=True)

    class Meta:
        model = User
        fields = [
            *base_user_fields,
            "password",
            "first_name",
            "last_name",
        ]
        extra_kwargs = {"phone_number": {"required": True}}


class UserSignUpWithOTPSerializer(serializers.ModelSerializer[UserType]):
    password = serializers.CharField(max_length=200, write_only=True)

    class Meta:
        model = User
        fields = [
            *base_user_fields,
            "password",
            "first_name",
            "last_name",
            "otp",
        ]
        extra_kwargs = {"phone_number": {"required": True}, "otp": {"read_only": True}}


class CustomUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = [
            *base_user_fields,
            "first_name",
            "last_name",
            "login_pin",
            "transaction_pin",
        ]
        extra_kwargs = {
            **base_extra_kwargs,
            "email": {"read_only": True},
            "phone_number": {"read_only": True},
            "first_name": {"read_only": True},
            "last_name": {"read_only": True},
            "transaction_pin": {"read_only": True},
            "login_pin": {"required": True},
        }

        def save(self, **kwargs):
            with transaction.atomic():
                user = self.context["request"].user
                user.login_pin = self.validated_data["login_pin"]
                user.save()
                return user


class SetUserTransactionPinSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = [
            "transaction_pin",
        ]
        extra_kwargs = {
            "transaction_pin": {"required": True, "write_only": True},
        }

        def save(self, **kwargs):
            with transaction.atomic():
                user = self.context["request"].user
                user.transaction_pin = self.validated_data["transaction_pin"]
                user.save()
                return user


class ObtainTokenSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(write_only=True, required=True)
    password = serializers.CharField(write_only=True, required=True)

    class Meta:
        model = User
        fields = ("email", "password")


class ObtainTokenWithPinSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(write_only=True, required=True)
    login_pin = serializers.CharField(write_only=True, required=True)

    def validate(self, data, *args, **kwargs):
        request = self.context["request"]
        email = data["email"]
        login_pin = data["login_pin"]
        user = User.objects.filter(email=email).first()
        if user is None or not user.check_login_pin(login_pin):
            raise serializers.ValidationError({"login_pin": "Invalid Login Pin !"})

        if user.is_verified is False:
            # send email verification link
            data = {"email": email}
            verify_email_serializer = SendEmailVerificationTokenSerializer(
                data=data,
                context={"request": request},
            )
            verify_email_serializer.is_valid(raise_exception=True)
            verify_email_serializer.send()
            raise serializers.ValidationError(
                "A verification link has been sent to your email !"
            )
        return data

    class Meta:
        model = User
        fields = ("email", "login_pin")


class ResetPasswordSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, required=True)
    confirm_password = serializers.CharField(write_only=True, required=True)

    class Meta:
        model = User
        fields = ("password", "confirm_password")

    def validate(self, data, *args, **kwargs):
        password = data["password"]
        confirm_password = data["confirm_password"]
        if password != confirm_password:
            raise serializers.ValidationError(
                {"password": "Password and Confirm Password Don't Match !"}
            )
        return data

    def update(self, instance, validated_data):
        with transaction.atomic():
            user = self.context["request"].user
            if user.pk != instance.pk:
                raise serializers.ValidationError(
                    {"authorize": "You dont have permission for this user."}
                )

            instance.set_password(validated_data["password"])
            instance.save()

        return instance


class ChangePasswordSerializer(serializers.ModelSerializer):
    current_password = serializers.CharField(write_only=True, required=True)
    new_password = serializers.CharField(write_only=True, required=True)
    confirm_password = serializers.CharField(write_only=True, required=True)

    class Meta:
        model = User
        fields = ("current_password", "new_password", "confirm_password")

    def validate(self, data, *args, **kwargs):
        user = self.context["request"].user
        current_password = data["current_password"]
        if not user.check_password(current_password):
            raise serializers.ValidationError(
                {"current_password": "Current Password is wrong !"}
            )

        new_password = data["new_password"]
        confirm_password = data["confirm_password"]

        if new_password != confirm_password:
            raise serializers.ValidationError(
                {
                    "new_password": "New Password and Confirm Password Don't Match !",
                    "confirm_password": "New Password and Confirm Password Don't Match !",
                }
            )
        return data

    def update(self, instance, validated_data):
        with transaction.atomic():
            user = self.context["request"].user
            if user.pk != instance.pk:
                raise serializers.ValidationError(
                    {"authorize": "You dont have permission for this user."}
                )

            instance.set_password(validated_data["new_password"])
            instance.save()

        return instance


class UpdateProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = (
            "first_name",
            "last_name",
            "phone_number",
            "location",
            "image",
        )
