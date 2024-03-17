from rest_framework.test import APITestCase
from django.urls import reverse

# serializers

# models
from landvest.users.models import User


class GlobalAPITestCase(APITestCase):
    def setUp(self) -> None:
        # Create user for views
        self.username = "admin"
        self.password = "adminpassword"
        self.email = "admin@test.com"
        self.phone_number = "+254712345678"
        self.first_name = "Emmanuel"
        self.last_name = "Izuchukwu"
        self.login_pin = 854348
        self.user = User.objects.create_user(
            email=self.email,
            password=self.password,
            username=self.username,
            phone_number=self.phone_number,
            first_name=self.first_name,
            last_name=self.last_name,
            login_pin=self.login_pin,
        )
        # Create verified user for views
        self.verified_username = "verified"
        self.verified_password = "verifiedpassword"
        self.verified_email = "verified@test.com"
        self.verified_phone_number = "+254712345008"
        self.verified_first_name = "Emmanuel"
        self.verified_last_name = "Izuchukwu"
        self.verified_login_pin = 8548
        self.verified_user = User.objects.create_user(
            email=self.verified_email,
            password=self.verified_password,
            username=self.verified_username,
            phone_number=self.verified_phone_number,
            first_name=self.verified_first_name,
            last_name=self.verified_last_name,
            login_pin=self.verified_login_pin,
            is_verified=True,
        )
        # Create auth user for views
        self.auth_username = "authadmin"
        self.auth_password = "authadminpassword"
        self.auth_email = "authadmin@test.com"
        self.auth_phone_number = "auth+254712345678"
        self.auth_first_name = "authEmmanuel"
        self.auth_last_name = "authIzuchukwu"
        self.auth_user = User.objects.create_user(
            email=self.auth_email,
            password=self.auth_password,
            username=self.auth_username,
            phone_number=self.auth_phone_number,
            first_name=self.auth_first_name,
            last_name=self.auth_last_name,
        )
        return super().setUp()
