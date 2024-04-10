import 'package:landvext/src/core/constants/imports.dart';

class LoginEmailInput extends StatelessWidget {
  const LoginEmailInput({
    required this.translate,
    required this.submitted,
    required this.emailController,
    super.key,
  });

  final TranslateType translate;
  final bool submitted;
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) => CustomTextInput(
        validator: (value) {
          if ((value == null || value.isEmpty) ||
              !LandConstants.emailRegEx.hasMatch(value)) {
            return translate(
              'authentication:login_textfield_email_validation',
            );
          }

          return null;
        },
        hintText: translate('authentication:login_textfield_email'),
        textInputAction: TextInputAction.next,
        autovalidateMode: submitted
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
      );
}
