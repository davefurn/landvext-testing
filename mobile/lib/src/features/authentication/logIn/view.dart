import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/core/riverpod/providers.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool canAuthenticate = false;
  bool didAuthenticate = false;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();
  bool submitted = false;
  LoadingState state = LoadingState.normal;
  bool isVisible = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      state = LoadingState.normal;
    });

    passwordController = TextEditingController();
    emailController = TextEditingController();
  }

  Future<void> login() async {
    setState(() {
      state = LoadingState.loading;
    });

    await PostRequest.login(
      context,
      email: emailController.text,
      password: passwordController.text,
    );
    setState(() {
      state = LoadingState.normal;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
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
              107.51.verticalSpace,
              Texts(
                text: translate('authentication:login_title'),
                padding: 20.w,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 24.sp,
                      color: LandColors.textColorVeryBlack,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              50.verticalSpace,
              CustomTextInput(
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
              ),
              12.verticalSpace,
              CustomTextInput(
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
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                ),
              ),
              12.verticalSpace,
              Padding(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LoadingButton(
                      width: 279.w,
                      color: LandColors.mainColor,
                      state: state,
                      onTap: () {
                        setState(() => submitted = true);
                        if (_formKey.currentState!.validate()) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          login();
                        }
                      },
                      text: translate('authentication:login_title'),
                    ),
                    8.horizontalSpace,
                    Consumer(
                      builder: (context, ref, _) {
                        final biometricState = ref.watch(biometricProvider);
                        ref.watch(fingerPrintState);

                        return InkWell(
                          onTap: () async {
                            try {
                              setState(() {
                                state = LoadingState.loading;
                              });
                              await biometricState.checkBiometricStatus(
                                context,
                                ref,
                              );
                              setState(() {
                                state = LoadingState.normal;
                              });
                            } on PlatformException catch (e) {
                              if (kDebugMode) {
                                print(e);
                              }
                            }
                          },
                          child: Container(
                            height: 48.h,
                            width: 48.w,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1.14,
                                  color: Colors.black
                                      .withOpacity(0.20000000298023224),
                                ),
                                borderRadius: BorderRadius.circular(4.57),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.fingerprint,
                                size: 32.sp,
                                color: LandColors.ascentColor,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              48.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      text: translate(
                        'authentication:login_textfield_have_account',
                      ),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: LandColors.textColorGrey,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                          ),
                      children: [
                        TextSpan(
                          text: 'Create one',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: LandColors.mainColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.goNamed(
                                  AppRoutes.signupPersonalDetails.name,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              19.4.verticalSpace,
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20.w,
                  ),
                  child: InkWell(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool('signupFlag', false);
                      if (context.mounted) {
                        await context.pushNamed(
                          AppRoutes.resetPassword.name,
                        );
                      }
                    },
                    child: RichText(
                      text: TextSpan(
                        text: translate(
                          'authentication:login_textfield_forgot_password',
                        ),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: LandColors.mainColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
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
