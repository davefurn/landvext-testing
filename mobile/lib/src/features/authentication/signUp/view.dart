import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/features/authentication/signUp/model/sign_up.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({Key? key}) : super(key: key);

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final UserModel userModel = UserModel();
  LoadingState state = LoadingState.normal;
  bool isVisible = true;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController phoneController;
  late TextEditingController referralController;

  final _formKey = GlobalKey<FormState>();
  bool submitted = false;
  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    referralController = TextEditingController();
  }

  Future<void> create() async {
    setState(() {
      state = LoadingState.loading;
    });
    await PostRequest.createUser(
      context,
      email: emailController.text,
      password: passwordController.text,
      phone: phoneController.text.trim(),
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      referralCode: referralController.text,
    );

    setState(() {
      state = LoadingState.normal;
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    referralController.dispose();

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
                  vertical: 69.18.h,
                ).copyWith(bottom: 0.h),
                child: SvgPicture.asset(
                  LandAssets.logo,
                ),
              ),
              25.16.verticalSpace,
              Texts(
                text: translate('authentication:signup_title'),
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
                  if (value == null || value.isEmpty) {
                    return translate(
                      'authentication:signup_personal_textfield_validator',
                    );
                  }

                  return null;
                },
                hintText: translate(
                  'authentication:signup_personal_textfield_first_name',
                ),
                textInputAction: TextInputAction.next,
                autovalidateMode: submitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                keyboardType: TextInputType.name,
                controller: firstNameController,
              ),
              16.verticalSpace,
              CustomTextInput(
                textInputAction: TextInputAction.next,
                controller: lastNameController,
                hintText: translate(
                  'authentication:signup_personal_textfield_last_name',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return translate(
                      'authentication:signup_personal_textfield_validator',
                    );
                  } else if (!LandConstants.nameExp.hasMatch(v)) {
                    return translate(
                      'authentication:signup_personal_textfield_validator',
                    );
                  }
                  return null;
                },
                keyboardType: TextInputType.name,
                autovalidateMode: submitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
              ),
              16.verticalSpace,
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
                hintText: translate('authentication:signup_textfield_email'),
                textInputAction: TextInputAction.next,
                autovalidateMode: submitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
              ),
              16.verticalSpace,
              CustomTextInput(
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
                hintText:
                    translate('authentication:signup_textfield_phone_number'),
              ),
              16.verticalSpace,
              CustomTextInput(
                controller: passwordController,
                hintText: translate('authentication:signup_textfield_password'),
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
                    isVisible ? Icons.visibility_off : Icons.visibility,
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
                suffixText: 'Optional',
                controller: referralController,
                hintText: 'Enter referral code[Optional]',
                keyboardType: TextInputType.text,
                autovalidateMode: submitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
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
                      create();
                    }
                  },
                  text: translate('authentication:signup_title'),
                ),
              ),
              24.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      text: translate(
                        'authentication:signup_textfield_have_account',
                      ),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: LandColors.textColorGrey,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                          ),
                      children: [
                        TextSpan(
                          text: translate(
                            'authentication:signup_textfield_have_account_main_text',
                          ),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: LandColors.mainColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.goNamed(
                                  AppRoutes.logIn.name,
                                ),
                        ),
                      ],
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
