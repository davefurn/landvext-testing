from django.contrib import admin
from django.contrib.auth import admin as auth_admin
from django.contrib.auth import get_user_model
from django.utils.translation import gettext_lazy as _

from landvest.users.forms import UserAdminChangeForm, UserAdminCreationForm

User = get_user_model()

admin.site.site_header = "LandVest Admin"
admin.site.site_title = "LandVest Admin Portal"
admin.site.index_title = "Welcome to LandVest Portal"


@admin.register(User)
class UserAdmin(auth_admin.UserAdmin):
    form = UserAdminChangeForm
    add_form = UserAdminCreationForm
    fieldsets = (
        (None, {"fields": ("email", "username", "password", "is_verified")}),
        (_("Personal info"), {"fields": ("first_name", "last_name", "phone_number")}),
        (
            _("Permissions"),
            {
                "fields": (
                    "is_active",
                    "is_staff",
                    "is_superuser",
                    "groups",
                    "user_permissions",
                ),
            },
        ),
        (_("Important dates"), {"fields": ("last_login", "date_joined")}),
    )
    list_display = [
        "email",
        "first_name",
        "last_name",
        "username",
        "is_verified",
        "is_superuser",
        "password_reset_token_expiry",
    ]
    search_fields = [
        "first_name",
        "last_name",
    ]
    ordering = ["id"]
    add_fieldsets = (
        (
            None,
            {
                "classes": ("wide",),
                "fields": ("email", "password1", "password2"),
            },
        ),
    )
