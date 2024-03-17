from rest_framework import serializers
from landvest.utils import generate_transaction_id, get_percentage_of_amount
from landvest.finance.models import Savings, SavingsTransaction, Wallet, WalletTransaction
from landvest.users.api.v1.users.serializers import CustomUserSerializer
from django.utils import timezone
from django.db import transaction


base_fields = [
    "id",
    "date_created",
    "date_modified",
]

base_extra_kwargs = {
    "date_created": {"read_only": True},
    "date_modified": {"read_only": True},
    "id": {"read_only": True},
}


class SavingsSerializer(serializers.ModelSerializer):
    user = CustomUserSerializer(many=False, read_only=True)

    class Meta:
        model = Savings
        fields = [
            *base_fields,
            "title",
            "user",
            "withdrawal_date",
            "target",
            "current_balance",
        ]
        extra_kwargs = {
            **base_extra_kwargs,
            "current_balance": {"read_only": True},
            "target": {"read_only": True},
        }


class CreateSavingsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Savings
        fields = [
            *base_fields,
            "title",
            "user",
            "withdrawal_date",
            "target",
            "current_balance",
        ]
        extra_kwargs = {
            **base_extra_kwargs,
            "current_balance": {"read_only": True},
            "title": {"required": True},
            "target": {"required": True},
            "withdrawal_date": {"required": True},
            "user": {"write_only": True, "required": True},
        }

    def is_valid(self, *args, **kwargs):
        request = self.context["request"]
        data = request.data
        title = data['title']
        # check if user and title is unique
        user = request.user
        not_unique = Savings.objects.only('user','title').filter(user=user,title=title).exists()
        if not_unique:
            raise serializers.ValidationError({'title': 'a you have an existing savings with the this title'})
        else:
            pass
        return super().is_valid(*args, **kwargs)


class UpdateSavingsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Savings
        fields = [
            *base_fields,
            "title",
            "target",
            "withdrawal_date",
            "current_balance",
        ]
        extra_kwargs = {
            **base_extra_kwargs,
            "title": {"required": True},
            "withdrawal_date": {"read_only": True},
            "current_balance": {"read_only": True},
            "target": {"read_only": True},
        }

    def is_valid(self, *args, **kwargs):
        request = self.context["request"]
        vkwargs = self.context["kwargs"]
        pk = vkwargs.get('pk')
        data = request.data
        title = data['title']
        # get instance
        instance = Savings.objects.get(id=pk)
        # if the title is the same, do nothing
        if instance.title == title:
            pass
        else:
            # check if user and title is unique
            user = request.user
            not_unique = Savings.objects.only('user','title').filter(user=user,title=title).exists()
            if not_unique:
                raise serializers.ValidationError({'title': 'a you have an existing savings with the this title'})
            else:
                pass
        return super().is_valid(*args, **kwargs)


class UserSavingsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Savings
        fields = [
            *base_fields,
            "title",
            "user",
            "target",
            "withdrawal_date",
            "current_balance",
        ]
        extra_kwargs = {
            **base_extra_kwargs,
            "title": {"required": True},
            "user": {"write_only": True, "required": True},
            "withdrawal_date": {"read_only": True},
            "current_balance": {"read_only": True},
            "target": {"read_only": True},
        }


class SavingsToWalletWithdrawal(serializers.ModelSerializer):
    class Meta:
        model = Savings
        fields = [
            *base_fields,
        ]
        extra_kwargs = {
            **base_extra_kwargs,
        }

    def save(self, **kwargs):
        with transaction.atomic():
            # get request object
            request = self.context['request']
            # get kwargs object
            kwargs = self.context['kwargs']
            # get user
            user = request.user
            # get user wallet
            user_wallet = None
            # get user savings
            user_savings = None
            savings_pk = kwargs.get('pk')
            try:
                user_wallet = Wallet.objects.get(user=user)
            except:
                raise serializers.ValidationError(
                    {"message": "This user doesn't have a wallet !"}
                )
            try:
                user_savings = Savings.objects.get(pk=savings_pk)
            except:
                raise serializers.ValidationError(
                    {"message": "This Savings Doesn't Exist !"}
                )
            # move money from savings to wallet
            # create internal_transaction_id for savings and wallet transactions
            internal_transaction_id = generate_transaction_id()
            # create savings debit transaction
            transaction_type = "DEBIT"
            status = 'PENDING'
            savings = user_savings
            balance_on_transaction = savings.current_balance
            amount = balance_on_transaction
            source = "SAVINGS"
            destination = "WALLET"
            stransaction:SavingsTransaction = savings.transactions.create(
                internal_transaction_id = internal_transaction_id,
                transaction_type = transaction_type,
                status = status,
                balance_on_transaction = balance_on_transaction,
                amount = amount,
                savings = savings,
                source = source,
                destination = destination,
            )
            # create wallet credit transaction
            wallet = user_wallet
            transaction_type = "CREDIT"
            status = 'PENDING'
            balance_on_transaction = wallet.current_balance
            amount = stransaction.amount
            # check if withdrawal is too soon
            if savings.withdrawal_date > timezone.now():
                # remove 10%
                amount = get_percentage_of_amount(90, amount)
            wtransaction:WalletTransaction = wallet.transactions.create(
                internal_transaction_id = internal_transaction_id,
                transaction_type = transaction_type,
                status = status,
                balance_on_transaction = balance_on_transaction,
                amount = amount,
                wallet = wallet,
                source = source,
                destination = destination,
            )

            stransaction.status = 'SUCCESS'
            wtransaction.status = 'SUCCESS'

            stransaction.save()
            wtransaction.save()

        return super().save(**kwargs)


class WalletToSavingsTopUp(serializers.ModelSerializer):
    amount = serializers.IntegerField()

    class Meta:
        model = Savings
        fields = [
            'amount'
        ]
        extra_kwargs = {
            'amount': {"read_only": True, "required": True}
        }

    def save(self, **kwargs):
        with transaction.atomic():
            # get request object
            request = self.context['request']
            # get amount
            amount = self.validated_data['amount']
            # get kwargs object
            kwargs = self.context['kwargs']
            # get user
            user = request.user
            # get user wallet
            user_wallet = None
            # get user savings
            user_savings = None
            savings_pk = kwargs.get('pk')
            try:
                user_wallet = Wallet.objects.get(user=user)
            except:
                raise serializers.ValidationError(
                    {"message": "This user doesn't have a wallet !"}
                )
            try:
                user_savings = Savings.objects.get(pk=savings_pk)
            except:
                raise serializers.ValidationError(
                    {"message": "This Savings Doesn't Exist !"}
                )
            # move money from wallet to savings
            # create internal_transaction_id for savings and wallet transactions
            internal_transaction_id = generate_transaction_id()
            amount = amount
            source = "WALLET"
            destination = "SAVINGS"
            # create savings credit transaction
            transaction_type = "CREDIT"
            status = 'PENDING'
            savings = user_savings
            balance_on_transaction = savings.current_balance
            stransaction:SavingsTransaction = savings.transactions.create(
                internal_transaction_id = internal_transaction_id,
                transaction_type = transaction_type,
                status = status,
                balance_on_transaction = balance_on_transaction,
                amount = amount,
                savings = savings,
                source = source,
                destination = destination,
            )
            # create wallet debit transaction
            wallet = user_wallet
            transaction_type = "DEBIT"
            status = 'PENDING'
            balance_on_transaction = wallet.current_balance
            amount = amount
            # check if withdrawal is too soon
            wtransaction:WalletTransaction = wallet.transactions.create(
                internal_transaction_id = internal_transaction_id,
                transaction_type = transaction_type,
                status = status,
                balance_on_transaction = balance_on_transaction,
                amount = amount,
                wallet = wallet,
                source = source,
                destination = destination,
            )

            stransaction.status = 'SUCCESS'
            wtransaction.status = 'SUCCESS'

            stransaction.save()
            wtransaction.save()

        return super().save(**kwargs)
