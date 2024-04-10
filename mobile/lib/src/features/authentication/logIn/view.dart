import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/riverpod/biometrics/bio.dart';
import 'package:landvext/src/core/riverpod/biometrics/bio_dialog.dart';
import 'package:landvext/src/core/services/postRequests/requests/login.dart';
import 'package:landvext/src/features/authentication/logIn/widget/fingerprint.dart';
import 'package:landvext/src/features/authentication/widgets/text_input_emails.dart';
import 'package:landvext/src/features/authentication/widgets/text_input_password.dart';

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
  BiometricLoad load = BiometricLoad.normal;
  @override
  void initState() {
    super.initState();
    setState(() {
      state = LoadingState.normal;
      load = BiometricLoad.normal;
    });

    passwordController = TextEditingController();
    emailController = TextEditingController();
    if (Platform.isAndroid) {
      InAppUpdate.checkForUpdate().then((updateInfo) {
        if (updateInfo.updateAvailability ==
            UpdateAvailability.updateAvailable) {
          if (updateInfo.immediateUpdateAllowed) {
            // Perform immediate update
            InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
              if (appUpdateResult == AppUpdateResult.success) {
                //App Update successful
              }
            });
          } else if (updateInfo.flexibleUpdateAllowed) {
            //Perform flexible update
            InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
              if (appUpdateResult == AppUpdateResult.success) {
                //App Update successful
                InAppUpdate.completeFlexibleUpdate();
              }
            });
          }
        }
      });
    }
  }

  Future<void> login() async {
    var data = LoginData(
      referralCode: 'referralCode',
      token: Token(
          refreshToken: 'refreshToken',
          accessToken:
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzEyODY5MTA5LCJpYXQiOjE3MTI3ODI3MDksImp0aSI6IjllZWEzMzEyMTFjYTQ2NmFhZmZiOGE3Y2QxMmZmN2Y0IiwidXNlcl9pZCI6NDd9.Lbs0LBDeWd_ATP293d9x7r6hnp7jWMzsRHmi4yBW1I0'),
      email: 'email',
      firstName: 'firstName',
      lastName: 'lastName',
      phoneNumber: 'phoneNumber',
      currentBalance: 0.0,
      referralPoints: 0.0,
    );
    context.goNamed(
      AppRoutes.home.name,
      extra: data,
    );
    // setState(() {
    //   state = LoadingState.loading;
    // });

    // // await PostRequestLogin.login(
    // //   context,
    // //   email: emailController.text,
    // //   password: passwordController.text,
    // // );
    // setState(() {
    //   state = LoadingState.normal;
    // });
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
              LoginEmailInput(
                translate: translate,
                submitted: submitted,
                emailController: emailController,
              ),
              12.verticalSpace,
              LoginPasswordInput(
                passwordController: passwordController,
                translate: translate,
                isVisible: isVisible,
                submitted: submitted,
                onpressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
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
                          if (context.mounted) {
                            login();
                          }
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
                                load = BiometricLoad.loading;
                              });
                              await biometricState.checkBiometricStatus(
                                context,
                                ref,
                              );
                              setState(() {
                                load = BiometricLoad.normal;
                              });
                            } on PlatformException catch (e) {
                              setState(() {
                                load = BiometricLoad.normal;
                              });
                              if (kDebugMode) {
                                print(e);
                              }
                            }
                          },
                          child: FingerPrintWidget(
                            state: load,
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
