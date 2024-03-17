from django.contrib import admin

from landvest.finance.models import (
    Deal,
    DealImage,
    DealPrice,
    Investment,
    Savings,
    Wallet,
    WalletTransaction,
    SavingsTransaction,
    Webhook,
)


# Register your models here.
@admin.register(Deal)
class DealAdmin(admin.ModelAdmin):
    model = Deal
    list_display = [
        "title",
        "current_price",
    ]


@admin.register(DealPrice)
class DealPriceAdmin(admin.ModelAdmin):
    model = DealPrice


@admin.register(Webhook)
class WebhookAdmin(admin.ModelAdmin):
    model = Webhook


@admin.register(DealImage)
class DealImageAdmin(admin.ModelAdmin):
    model = DealImage


@admin.register(Wallet)
class WalletAdmin(admin.ModelAdmin):
    model = Wallet
    list_display = [
        "user",
        "current_balance",
    ]


@admin.register(Savings)
class SavingsAdmin(admin.ModelAdmin):
    model = Savings
    list_display = [
        "user",
        "title",
        "target",
        "withdrawal_date",
        "current_balance",
    ]


@admin.register(WalletTransaction)
class WalletTransactionAdmin(admin.ModelAdmin):
    model = WalletTransaction
    list_display = [
        "amount",
        "balance_on_transaction",
        "transaction_type",
        "status",
        "source",
        "destination",
    ]


@admin.register(SavingsTransaction)
class SavingsTransactionAdmin(admin.ModelAdmin):
    model = SavingsTransaction
    list_display = [
        "amount",
        "balance_on_transaction",
        "transaction_type",
        "status",
        "source",
        "destination",
    ]


@admin.register(Investment)
class InvestmentAdmin(admin.ModelAdmin):
    model = Investment
