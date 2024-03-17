from rest_framework import status
from rest_framework.response import Response

from functools import wraps

from landvest.finance.models import Savings


def user_passes_savings_test(test_func):
    def decorator(view_func):
        @wraps(view_func)
        def _wrapper_view(request, *args, **kwargs):
            savings_id = kwargs.get("pk")
            user_id = request.user.id
            if test_func(user_id, savings_id):
                return view_func(request, *args, **kwargs)
            return Response("this savings doesn't belong to you !", status=status.HTTP_403_FORBIDDEN)

        return _wrapper_view

    return decorator


def parseDateTime(value):
    from django.utils import dateparse

    return dateparse.parse_datetime(value)
