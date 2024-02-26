import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvest/src/core/constants/imports.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late TextEditingController confirmController;
  late TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();
  bool submitted = false;
  late AssetImage assets;
  LoadingState state = LoadingState.normal;
  bool isVisible = false;

  @override
  void initState() {
    super.initState();

    passwordController = TextEditingController();
    confirmController = TextEditingController();
  }

  Future<void> confirmPassword() async {
    setState(() {
      state = LoadingState.loading;
    });
    await PostRequest.resetPassword(
      context,
      confirmPassword: confirmController.text,
      password: passwordController.text,
    );

    setState(() {
      state = LoadingState.normal;
    });
  }

  @override
  void dispose() {
    confirmController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 77.6.h,
                ).copyWith(bottom: 0.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        context.pop();
                      },
                      child: SvgPicture.asset(
                        LandAssets.backThree,
                      ),
                    ),
                    SizedBox(
                      height: 47.936.h,
                      width: 47.936.w,
                    ),
                  ],
                ),
              ),
              31.56.verticalSpace,
              Texts(
                text: translate('authentication:forgot_password_title'),
                padding: 20.w,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 24.sp,
                      color: LandColors.textColorVeryBlack,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              50.verticalSpace,
              CustomTextInput(
                autovalidateMode: submitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
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
                controller: passwordController,
                hintText: translate('authentication:login_textfield_password'),
                obscureText: isVisible,
                keyboardType: TextInputType.visiblePassword,
                suffixIcon: IconButton(
                  splashColor: LandColors.transparent,
                  highlightColor: LandColors.transparent,
                  iconSize: 18.sp,
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                    color: LandColors.textColorHintGrey,
                  ),
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                ),
              ),
              12.verticalSpace,
              CustomTextInput(
                autovalidateMode: submitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
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
                controller: confirmController,
                hintText: translate(
                  'authentication:forgot_password_textfield_confirm_password',
                ),
                obscureText: isVisible,
                keyboardType: TextInputType.visiblePassword,
                suffixIcon: IconButton(
                  splashColor: LandColors.transparent,
                  highlightColor: LandColors.transparent,
                  iconSize: 18.sp,
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
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
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                ),
                child: LoadingButton(
                  color: LandColors.mainColor,
                  state: state,
                  onTap: () {
                    setState(() => submitted = true);
                    if (_formKey.currentState!.validate()) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      confirmPassword();
                    }
                  },
                  text: translate(
                    'authentication:forgot_password_custom_button',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
