import 'dart:async';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/services/postRequests/requests/email_sent_signup.dart';
import 'package:landvext/src/core/services/postRequests/requests/verify_email.dart';
import 'package:landvext/src/features/authentication/forgotPassword/widgets/back_button.dart';
import 'package:landvext/src/features/authentication/forgotPassword/widgets/count_down.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EmailValidation extends StatefulWidget {
  const EmailValidation({super.key});

  @override
  State<EmailValidation> createState() => _EmailValidationState();
}

class _EmailValidationState extends State<EmailValidation> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController textEditingController;
  late StreamController<ErrorAnimationType> errorController;
  String currentText = '';
  String resetToken = '';
  String email = '';
  int countdown = 60;
  bool timerActive = false;
  LoadingState state = LoadingState.normal;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();

    errorController = StreamController<ErrorAnimationType>();
    LocalStorage.instance.getEmail().then((value) {
      email = '$value';
    });
    LocalStorage.instance.getResetToken().then((value) {
      resetToken = '$value';
    });
    setState(() {});

    startTimer();
  }

  void startTimer() {
    setState(() {
      timerActive = true;
    });
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (timer) {
      if (mounted) {
        newMethod(timer);
      } else {
        timer.cancel();
      }
    });
  }

  void newMethod(Timer timer) {
    countdown == 0
        ? setState(() {
            timer.cancel();
            timerActive = false;
          })
        : setState(() {
            countdown--;
          });
  }

  Future<void> verifyEmail() async {
    setState(() {
      state = LoadingState.loading;
    });
    await PostRequestVerifyEmail.verifyEmail(
      context,
      email: email,
      passwordResetToken: textEditingController.text,
    );
    setState(() {
      state = LoadingState.normal;
    });
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackButtonss(
              ontap: () {
                context.goNamed(AppRoutes.logIn.name);
              },
            ),
            31.56.verticalSpace,
            Texts(
              text: translate(
                'authentication:email_validation_title',
              ),
              padding: 20.w,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 24.sp,
                    color: LandColors.textColorVeryBlack,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            14.84.verticalSpace,
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Text(
                translate(
                  'authentication:email_validation_description',
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: LandColors.textColorHintGrey,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
              ),
            ),
            50.verticalSpace,
            PinCodeTextField(
              onCompleted: (value) {
                _formKey.currentState!.validate();

                FocusManager.instance.primaryFocus?.unfocus();
                verifyEmail();
              },
              errorAnimationController: errorController,
              errorAnimationDuration: 300,
              controller: textEditingController,
              keyboardType: TextInputType.number,
              animationType: AnimationType.none,
              cursorColor: LandColors.textColorVeryBlack,
              mainAxisAlignment: MainAxisAlignment.center,
              obscuringCharacter: '-',
              cursorHeight: 19.h,
              enableActiveFill: true,
              textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: LandColors.textColorVeryBlack,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                fieldHeight: 75.328.h,
                fieldWidth: 74.75.w,
                borderRadius: BorderRadius.all(
                  Radius.circular(4.r),
                ),
                borderWidth: 1,
                fieldOuterPadding: EdgeInsets.symmetric(horizontal: 6.w),
                activeFillColor: LandColors.textColorHint,
                inactiveColor: LandColors.textColorHint,
                inactiveFillColor: LandColors.textColorHint,
                selectedFillColor: LandColors.textColorHint,
                selectedColor: LandColors.textColorHint,
                activeColor: LandColors.mainColor,
              ),
              appContext: context,
              length: 4,
              onChanged: (value) {
                setState(() {
                  currentText = value;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CountDown(
                    translate: translate,
                    timerActive: timerActive,
                    countdown: countdown,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (countdown == 0) {
                            setState(() {
                              countdown = 60;
                            });

                            await PostRequestEmailSentSignUp.emailSentSignUp(
                              context,
                              email: email,
                            ).then((value) {
                              if (value == 200) {
                                setState(() {
                                  countdown = 60;
                                });
                                startTimer();
                              } else {
                                return;
                              }
                            });
                          } else {
                            return;
                          }
                        },
                        child: Text(
                          translate(
                            'authentication:email_validation_recieve_code_resend',
                          ),
                          style: TextStyle(
                            fontSize: 15.978666305541992.sp,
                            color: countdown == 0
                                ? LandColors.mainColor
                                : LandColors.textColorHintGrey,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            24.verticalSpace,
            Padding(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
              ),
              child: LoadingButton(
                color: LandColors.mainColor,
                state: state,
                text: translate(
                  'authentication:email_validation_button_title',
                ),
                onTap: () {
                  _formKey.currentState!.validate();

                  FocusManager.instance.primaryFocus?.unfocus();
                  verifyEmail();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
