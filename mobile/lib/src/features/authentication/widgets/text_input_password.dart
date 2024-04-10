import 'package:landvext/src/core/constants/imports.dart';

class LoginPasswordInput extends StatelessWidget {
  const LoginPasswordInput({
    required this.passwordController,
    required this.translate,
    required this.isVisible,
    required this.submitted,
    required this.onpressed,
    super.key,
  });

  final TextEditingController passwordController;
  final TranslateType translate;
  final bool isVisible;
  final bool submitted;
  final VoidCallback onpressed;

  @override
  Widget build(BuildContext context) => CustomTextInput(
        controller: passwordController,
        hintText: translate('authentication:login_textfield_password'),
        validator: (v) {
          if (v == null || v.isEmpty || v.trim().length < 8) {
            return translate(
              'authentication:login_textfield_password_validation_character_size',
            );
          } else if (!LandConstants.checkLettersregEx.hasMatch(v)) {
            return translate(
              'authentication:login_textfield_password_validation_cases',
            );
          }
          return null; // to indicate a success
        },
        obscureText: isVisible,
        keyboardType: TextInputType.visiblePassword,
        autovalidateMode: submitted
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        suffixIcon: IconButton(
          splashColor: LandColors.transparent,
          highlightColor: LandColors.transparent,
          iconSize: 18.sp,
          icon: Icon(
            isVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: LandColors.textColorHintGrey,
          ),
          onPressed: onpressed,
        ),
      );
}
