import 'package:landvext/src/core/constants/imports.dart';

class NameInput extends StatelessWidget {
  const NameInput({
    required this.translate,
    required this.submitted,
    required this.firstNameController,
    required this.hint,
    super.key,
  });

  final TranslateType translate;
  final bool submitted;
  final TextEditingController firstNameController;
  final String hint;

  @override
  Widget build(BuildContext context) => CustomTextInput(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return translate(
              'authentication:signup_personal_textfield_validator',
            );
          }

          return null;
        },
        hintText: hint,
        textInputAction: TextInputAction.next,
        autovalidateMode: submitted
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        keyboardType: TextInputType.name,
        controller: firstNameController,
      );
}

class PhoneInput extends StatelessWidget {
  const PhoneInput({
    required this.submitted,
    required this.translate,
    required this.phoneController,
    super.key,
  });

  final bool submitted;
  final TranslateType translate;
  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) => CustomTextInput(
        autovalidateMode: submitted
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        validator: (value) {
          if (value!.isEmpty) {
            return translate(
              'authentication:signup_textfield_phone_validation_phone',
            );
          } else if (!LandConstants.phoneExp.hasMatch(value)) {
            return translate(
              'authentication:signup_textfield_phone_validation_phone_valid',
            );
          }
          return null;
        },
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.phone,
        controller: phoneController,
        hintText: translate('authentication:signup_textfield_phone_number'),
      );
}
