from django.conf import settings
from django.contrib.auth.models import AbstractUser
from django.db.models import CharField, EmailField, TextField
from django.urls import reverse
from django.utils.translation import gettext_lazy as _

from landvest.users.managers import UserManager


class User(AbstractUser):
    """
    Default custom user model for landvest.
    If adding fields that need to be filled at user signup,
    check forms.SignupForm and forms.SocialSignupForms accordingly.
    """

    # First and last name do not cover name patterns around the globe
    # name = CharField(_("Name of User"), blank=True, max_length=255)
    first_name = CharField(_("First Name of User"), blank=True, max_length=255)
    last_name = CharField(_("Last Name of User"), blank=True, max_length=255)
    email = EmailField(_("Email Address"), unique=True)
    username = CharField(_("Username of User"), unique=True, blank=True, null=True, max_length=255)
    phone_number = CharField(_("Phone Number"), unique=True, default="")
    location = TextField(_("Location Detail"), blank=True, null=True)

    USERNAME_FIELD = settings.USERNAME_FIELD
    REQUIRED_FIELDS = []

    objects = UserManager()

    def get_absolute_url(self) -> str:
        """Get URL for user's detail view.

        Returns:
            str: URL for user detail.

        """
        return reverse("users:detail", kwargs={"pk": self.id})
