from django.db import models
from landvest.users.models import User
from django.utils import timezone


# Create your models here.
class CommonAbstractClass(models.Model):
    is_active = models.BooleanField(default=True)
    date_created = models.DateTimeField(auto_now_add=True, null=True, blank=True)  # date of creation of the record
    date_modified = models.DateTimeField(auto_now=True, null=True, blank=True)  # date of listing updated

    class Meta:
        ordering = ["-date_created"]
        abstract = True


class Deal(CommonAbstractClass):
    title = models.CharField(max_length=100)
    description = models.TextField()
    owner = models.ForeignKey(
        User, on_delete=models.CASCADE, blank=True, null=True
    )  # TO BIND THE CREATOR OF THE PROPERTY INCASE OF FUTURE USE
    location = models.TextField()
    thumbnail = models.ImageField(upload_to="deal_images", blank=True, null=True)
    units = models.IntegerField()
    can_outright = models.BooleanField(default=True)
    maturity_date = models.DateTimeField()
    area = models.FloatField()
    is_featured = models.BooleanField(default=False)

    @property
    def current_price(self):
        prices = self.prices.filter().order_by("-date_created")
        if prices.exists():
            return prices.first().price
        return 0

    def __str__(self):
        return self.title


class DealPrice(CommonAbstractClass):
    deal = models.ForeignKey(Deal, related_name="prices", on_delete=models.CASCADE)
    price = models.FloatField()

    def __str__(self):
        return f"{self.deal.title} - {self.price}"


class DealImage(CommonAbstractClass):
    deal = models.ForeignKey(Deal, related_name="gallery", on_delete=models.CASCADE)
    image = models.ImageField(upload_to="deal_images", blank=True, null=True)

    def __str__(self):
        return self.deal.title


class Savings(CommonAbstractClass):
    """
    charge per withdrawal before withdrawal_date
    """

    title = models.CharField(max_length=100, blank=True, null=True)
    user = models.ForeignKey(User, related_name="savings", on_delete=models.CASCADE)
    withdrawal_date = models.DateTimeField(blank=True, null=True)
    target = models.FloatField()

    class Meta:
        constraints = [
            models.constraints.UniqueConstraint(fields=["user", "title"], name="unique_user_title"),
        ]

    def __str__(self):
        return f"{self.user.email} savings"

    @property
    def current_balance(self):
        # Calculate the current balance by summing the transaction amounts
        debit_amount = (
            self.transactions.only("amount","transaction_type", "status")
            .filter(transaction_type="DEBIT", status="SUCCESS")
            .aggregate(total=models.Sum("amount"))["total"]
            or 0
        )
        credit_amount = (
            self.transactions.only("amount","transaction_type", "status")
            .filter(transaction_type="CREDIT", status="SUCCESS")
            .aggregate(total=models.Sum("amount"))["total"]
            or 0
        )

        return credit_amount - debit_amount


class Wallet(CommonAbstractClass):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="wallet")

    def __str__(self):
        return f"{self.user.email} wallet"

    @property
    def current_balance(self):
        # Calculate the current balance by summing the transaction amounts
        debit_amount = (
            self.transactions.only("amount","transaction_type", "status")
            .filter(transaction_type="DEBIT", status="SUCCESS")
            .aggregate(total=models.Sum("amount"))["total"]
            or 0
        )
        credit_amount = (
            self.transactions.only("amount","transaction_type", "status")
            .filter(transaction_type="CREDIT", status="SUCCESS")
            .aggregate(total=models.Sum("amount"))["total"]
            or 0
        )

        return credit_amount - debit_amount


TRANSACTION_TYPE_CHOICES = (
    ("CREDIT", "CREDIT"),
    ("DEBIT", "DEBIT"),
)

STATUS_CHOICES = (
    ("PENDING", "PENDING"),
    ("SUCCESS", "SUCCESS"),
    ("FAILED", "FAILED"),
)

SAVINGS_FLOW_CHOICES = (
    ("WALLET", "WALLET"),
    ("SAVINGS", "SAVINGS"),
)

WALLET_FLOW_CHOICES = (
    ("WALLET", "WALLET"),
    ("SAVINGS", "SAVINGS"),
    ("EXTERNAL", "EXTERNAL"),
)


class CommonAbstractTransaction(CommonAbstractClass):
    """
    - transaction_id
    - transaction_type # credit | debit
    - status # success|pending|failed
    - balance_on_transaction
    - amount
    """

    internal_transaction_id = models.CharField(max_length=100, blank=True, null=True)
    external_transaction_id = models.CharField(max_length=100, blank=True, null=True)
    transaction_type = models.CharField(
        max_length=100,
        default="DEBIT",
        choices=TRANSACTION_TYPE_CHOICES,
    )
    status = models.CharField(max_length=100, default="PENDING", choices=STATUS_CHOICES)
    balance_on_transaction = models.FloatField(default=0)
    amount = models.FloatField(default=0)

    class Meta:
        abstract = True


class SavingsTransaction(CommonAbstractTransaction):
    """
    - savings
    - transaction_id
    - transaction_type # credit | debit
    - status # success|pending|failed
    - balance_on_transaction
    - amount_transacted
    - from -> SAVINGS | WALLET
    - to -> SAVINGS | WALLET
    """

    savings = models.ForeignKey(Savings, related_name="transactions", on_delete=models.CASCADE)
    source = models.CharField(max_length=100, default="SAVINGS", choices=SAVINGS_FLOW_CHOICES)
    destination = models.CharField(max_length=100, default="WALLET", choices=SAVINGS_FLOW_CHOICES)


class WalletTransaction(CommonAbstractTransaction):
    """
    - wallet
    - transaction_id
    - transaction_type # credit | debit
    - status # success|pending|failed
    - balance_on_transaction
    - amount_transacted
    - from -> SAVINGS | WALLET | EXTERNAL
    - to -> SAVINGS | WALLET | EXTERNAL
    """

    wallet = models.ForeignKey(Wallet, related_name="transactions", on_delete=models.CASCADE)
    source = models.CharField(max_length=100, default="SAVINGS", choices=WALLET_FLOW_CHOICES)
    destination = models.CharField(max_length=100, default="WALLET", choices=WALLET_FLOW_CHOICES)


class Investment(CommonAbstractClass):
    deal = models.ForeignKey(Deal, related_name="investments", on_delete=models.CASCADE)
    investor = models.ForeignKey(User, on_delete=models.CASCADE)
    transaction = models.ForeignKey(WalletTransaction, related_name="investments", on_delete=models.CASCADE)
    amount = models.FloatField()
    deal_amount_on_purchase = models.ForeignKey(DealPrice, related_name="investments", on_delete=models.CASCADE)
    units = models.IntegerField()

    def __str__(self):
        return f"{self.deal.title} - {self.investor.email}"

    @property
    def current_price(self):
        return self.deal.current_price

    @property
    def profit(self):
        return self.current_price - self.deal_amount_on_purchase.price

    @property
    def percentage_profit(self):
        return (self.profit / self.deal_amount_on_purchase.price) * 100

    @property
    def is_matured(self):
        return self.deal.maturity_date <= timezone.now()

    @property
    def is_outright(self):
        return self.units == self.deal_amount_on_purchase.units


class Webhook(CommonAbstractClass):
    transaction_id = models.CharField(max_length=100)
    email = models.EmailField()
    body = models.TextField(null=True, blank=True)

    def __str__(self):
        return self.transaction_id
