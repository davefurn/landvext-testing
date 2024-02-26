from django.contrib.auth import get_user_model
from rest_framework import serializers

from landvest.users.models import User as UserType


User = get_user_model()

base_user_fields = [
    "email",
    "phone_number",
]


class UserSerializer(serializers.ModelSerializer[UserType]):
    class Meta:
        model = User
        fields = [
            *base_user_fields,
            "first_name",
            "last_name",
            "username",
        ]


class UserSignUpSerializer(serializers.ModelSerializer[UserType]):
    password = serializers.CharField(max_length=200)
    class Meta:
        model = User
        fields = [
        *base_user_fields,
        "password",
        ]


class CustomUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = [
            *base_user_fields,
            "first_name",
            "last_name",
        ]


class ObtainTokenSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(write_only=True, required=True)
    password = serializers.CharField(write_only=True, required=True)

    class Meta:
        model = User
        fields = (
            'email',
            'password'
        )


class ForgotPasswordSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, required=True)
    confirm_password = serializers.CharField(write_only=True, required=True)

    class Meta:
        model = User
        fields = (
            'password',
            'confirm_password'
        )

    def validate(self, data, *args, **kwargs):
        password = data['password']
        confirm_password = data['confirm_password']
        if password != confirm_password:
            raise serializers.ValidationError({"password" : "Password and Confirm Password Don't Match !"})
        return data

    def update(self, instance, validated_data):
        user = self.context['request'].user
        if user.pk != instance.pk:
            raise serializers.ValidationError({"authorize": "You dont have permission for this user."})

        instance.set_password(validated_data['password'])
        instance.save()

        return instance


class ChangePasswordSerializer(serializers.ModelSerializer):
    current_password = serializers.CharField(write_only=True, required=True)
    new_password = serializers.CharField(write_only=True, required=True)
    confirm_password = serializers.CharField(write_only=True, required=True)

    class Meta:
        model = User
        fields = (
            'current_password',
            'new_password',
            'confirm_password'
        )

    def validate(self, data, *args, **kwargs):
        user = self.context['request'].user
        current_password = data['current_password']
        if not user.check_password(current_password):
            raise serializers.ValidationError({"current_password" : "Current Password is wrong !"})

        new_password = data['new_password']
        confirm_password = data['confirm_password']

        if new_password != confirm_password:
            raise serializers.ValidationError({
                "new_password" : "New Password and Confirm Password Don't Match !",
                "confirm_password" : "New Password and Confirm Password Don't Match !",
            })
        return data

    def update(self, instance, validated_data):
        user = self.context['request'].user
        if user.pk != instance.pk:
            raise serializers.ValidationError({"authorize": "You dont have permission for this user."})

        instance.set_password(validated_data['new_password'])
        instance.save()

        return instance


class UpdateProfileSerializer(serializers.ModelSerializer):

    class Meta:
        model = User
        fields = (
            'first_name',
            'last_name',
            'phone_number',
            'location',
        )
