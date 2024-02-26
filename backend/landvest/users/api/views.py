from django.contrib.auth import get_user_model
from landvest.utils import get_tokens_for_user
from rest_framework import status
from rest_framework.decorators import action
from rest_framework.mixins import ListModelMixin
from rest_framework.response import Response
from rest_framework.viewsets import GenericViewSet
# jwt
from django.contrib.auth import get_user_model
from rest_framework import views, permissions, status
from rest_framework.response import Response
from .serializers import (
    ObtainTokenSerializer,
    CustomUserSerializer,
    UserSignUpSerializer,
    ChangePasswordSerializer,
    UserSerializer,
    ForgotPasswordSerializer,
    UpdateProfileSerializer,
)
from landvest.mixins import MultiSerializerClassMixin
# jwt


User = get_user_model()


class UserViewSet(ListModelMixin, MultiSerializerClassMixin, GenericViewSet):
    queryset = User.objects.all()
    lookup_field = "pk"
    serializer_action_classes = {
        "signup": UserSignUpSerializer,
        "forgot_password": ForgotPasswordSerializer,
        "change_password": ChangePasswordSerializer,
        "update_profile": UpdateProfileSerializer,
        "login": ObtainTokenSerializer,
        "me": UserSerializer
    }
    permissions_action_classes = {
        "forgot_password": [
            permissions.IsAuthenticated
        ],
        "change_password": [
            permissions.IsAuthenticated
        ],
        "update_profile": [
            permissions.IsAuthenticated
        ],
        "login": [
            permissions.AllowAny
        ]
    }

    @action(detail=False)
    def me(self, request):
        serializer = self.get_serializer(request.user, context={"request": request})
        return Response(status=status.HTTP_200_OK, data=serializer.data)

    @action(detail=False, methods=['post'], url_path='forgot-password')
    def forgot_password(self, request, *args, **kwargs):
        serializer = self.get_serializer(instance=request.user, data=request.data, context={"request": request})
        if serializer.is_valid(raise_exception=True):
            serializer.save()
        response = {
            "detail": "Password Changed Successfully !"
        }
        return Response(status=status.HTTP_200_OK, data=response)

    @action(detail=False, methods=['post'], url_path='change-password')
    def change_password(self, request, *args, **kwargs):
        serializer = self.get_serializer(instance=request.user, data=request.data, context={"request": request})
        if serializer.is_valid(raise_exception=True):
            serializer.save()
        response = {
            "detail": "Password Changed Successfully !"
        }
        return Response(status=status.HTTP_200_OK, data=response)

    @action(detail=False, methods=['post'], url_path='update-profile')
    def update_profile(self, request, *args, **kwargs):
        serializer = self.get_serializer(instance=request.user, data=request.data, context={"request": request})
        if serializer.is_valid(raise_exception=True):
            serializer.save()
        response = {
            "detail": "Profile Updated Successfully !"
        }
        return Response(status=status.HTTP_200_OK, data=serializer.data)

    @action(detail=False, methods=['post'])
    def login(self, request):
        serializer = self.get_serializer(data=request.data, context={"request": request})
        if serializer.is_valid(raise_exception=True):

            email = serializer.validated_data.get('email')
            password = serializer.validated_data.get('password')

            user = User.objects.filter(email=email).first()

            if user is None or not user.check_password(password):
                return Response({'detail': 'Invalid credentials'}, status=status.HTTP_400_BAD_REQUEST)
            user_serializer = CustomUserSerializer(user)

            # Generate the JWT token
            jwt_token = get_tokens_for_user(user)

            return Response({'token': jwt_token,**user_serializer.data})

    @action(detail=False, methods=['post'])
    def signup(self, request):
        serializer = self.get_serializer(data=request.data, context={"request": request})
        if serializer.is_valid(raise_exception=True):
            instance = serializer.save()
            password = self.request.data.get('password')
            # create user
            instance.set_password(password)
            instance.save()
            return Response(status=status.HTTP_200_OK, data=serializer.data)
        response = {}
        response['detail'] = "BAD REQUEST !"
        return Response(status=status.HTTP_400_BAD_REQUEST, data=response)


class ObtainTokenView(views.APIView):
    permission_classes = [permissions.AllowAny]
    serializer_class = ObtainTokenSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)

        email = serializer.validated_data.get('email')
        password = serializer.validated_data.get('password')

        user = User.objects.filter(email=email).first()

        if user is None or not user.check_password(password):
            return Response({'detail': 'Invalid credentials'}, status=status.HTTP_400_BAD_REQUEST)
        user_serializer = CustomUserSerializer(user)

        # Generate the JWT token
        jwt_token = get_tokens_for_user(user)

        return Response({'token': jwt_token, **user_serializer.data})
