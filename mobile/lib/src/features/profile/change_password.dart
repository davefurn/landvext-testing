import 'package:landvest/src/core/constants/imports.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isVisible = false;
  late TextEditingController currentPassword;
  late TextEditingController newPassword;
  late TextEditingController confirmPassword;
  LoadingState state = LoadingState.normal;
  final _formKey = GlobalKey<FormState>();
  bool submitted = false;
  @override
  void initState() {
    super.initState();
    currentPassword = TextEditingController();
    confirmPassword = TextEditingController();
    newPassword = TextEditingController();
  }

  Future<void> changePassword() async {
    setState(() {
      state = LoadingState.loading;
    });
    await PostRequest.changePassword(
      context,
      confirmPassword: confirmPassword.text,
      newPassword: newPassword.text,
      currentPassword: currentPassword.text,
    );

    setState(() {
      state = LoadingState.normal;
    });
  }

  @override
  void dispose() {
    confirmPassword.dispose();
    currentPassword.dispose();
    newPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Scaffold(
      appBar: CustomAppbar(
        translate: 'Change Password',
        appBar: AppBar(),
        widget: const SizedBox.shrink(),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            50.verticalSpace,
            CustomTextInput(
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
              autovalidateMode: submitted
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              hpD: 20.w,
              controller: currentPassword,
              hintText: translate(
                'profile:profile_personal_textfield_current_password_hint',
              ),
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
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
              ),
            ),
            16.verticalSpace,
            CustomTextInput(
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
              autovalidateMode: submitted
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              controller: newPassword,
              hpD: 20.w,
              hintText: translate(
                'profile:profile_personal_textfield_new_password_hint',
              ),
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
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
              ),
            ),
            16.verticalSpace,
            CustomTextInput(
              autovalidateMode: submitted
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              controller: confirmPassword,
              hpD: 20.w,
              validator: (v) {
                if (v == null || v.isEmpty || v.trim().length < 8) {
                  return translate(
                    'authentication:login_textfield_password_validation_character_size',
                  );
                } else if (!LandConstants.checkLettersregEx.hasMatch(v)) {
                  return translate(
                    'authentication:login_textfield_password_validation_cases',
                  );
                } else if (v != newPassword.text) {
                  return 'Password not similar to the new password';
                }
                return null; // to indicate a success
              },
              hintText: translate(
                'profile:profile_personal_textfield_re_enter_password_hint',
              ),
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
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
              ),
            ),
            16.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: LoadingButton(
                state: state,
                color: LandColors.mainColor,
                width: double.maxFinite,
                text: 'Change Password',
                onTap: () {
                  setState(() => submitted = true);
                  if (_formKey.currentState!.validate()) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    changePassword();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
