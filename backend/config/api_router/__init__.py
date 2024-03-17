from django.urls import path, include
from config.api_router.v1 import views

app_name = "api"
urlpatterns = [
    path("v1/", include("config.api_router.v1")),
    path("v1/webhook/", views.webhook),
    path(
        "verify-email-confirm/<uidb64>/<token>/",
        views.verify_email_confirm,
        name="verify-email-confirm",
    ),
    path(
        "verify-email/complete/",
        views.verify_email_complete,
        name="verify-email-complete",
    ),
]
