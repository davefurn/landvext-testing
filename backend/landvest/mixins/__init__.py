class MultiSerializerClassMixin:
    def get_serializer_class(self):
        try:
            return self.serializer_action_classes[self.action]
        except (KeyError, AttributeError):
            return super().get_serializer_class()

    @property
    def permission_classes(self):
        try:
            return self.permissions_action_classes[self.action]
        except (KeyError, AttributeError):
            return []
