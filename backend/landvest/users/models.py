from django.conf import settings
from django.contrib.auth.models import AbstractUser
from django.db.models import CharField, EmailField, TextField
from django.db import models
from django.utils.translation import gettext_lazy as _

from landvest.users.managers import UserManager


class User(AbstractUser):
    first_name = CharField(
        _("First Name of User"), blank=True, null=True, max_length=255
    )
    last_name = CharField(_("Last Name of User"), blank=True, null=True, max_length=255)
    email = EmailField(_("Email Address"), unique=True)
    username = CharField(
        _("Username of User"), unique=True, blank=True, null=True, max_length=255
    )
    phone_number = CharField(
        _("Phone Number"), unique=True, blank=True, null=True, max_length=100
    )
    location = TextField(_("Location Detail"), blank=True, null=True)
    image = models.ImageField(upload_to="user_images", blank=True, null=True)
    password_reset_token = CharField(max_length=10, blank=True, null=True)
    password_reset_token_expiry = models.DateTimeField(
        blank=True, null=True, auto_now_add=True
    )
    otp = CharField(max_length=10, blank=True, null=True)
    otp_expiry = models.DateTimeField(
        blank=True, null=True, auto_now_add=True
    )
    transaction_pin = models.CharField(max_length=6, null=True, blank=True)
    login_pin = models.CharField(max_length=6, null=True, blank=True)
    is_verified = models.BooleanField(default=False)

    USERNAME_FIELD = settings.USERNAME_FIELD
    REQUIRED_FIELDS = []

    objects = UserManager()

    def check_login_pin(self, pin):
        return self.login_pin == pin

    def check_transaction_pin(self, pin):
        return self.transaction_pin == pin
