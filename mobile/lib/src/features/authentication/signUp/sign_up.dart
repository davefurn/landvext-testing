import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/features/authentication/signUp/model/sign_up.dart';

class SignUp extends StatefulWidget {
  const SignUp({required this.userModel, Key? key}) : super(key: key);
  final UserModel userModel;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  LoadingState state = LoadingState.normal;
  bool isVisible = true;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController phoneController;

  final _formKey = GlobalKey<FormState>();
  bool submitted = false;
  @override
  void initState() {
    super.initState();

    passwordController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
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
      firstName: widget.userModel.firstName,
      lastName: widget.userModel.lastName,
    );

    setState(() {
      state = LoadingState.normal;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
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
              19.4.verticalSpace,
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
                      create();
                    }
                  },
                  text: translate('authentication:signup_title'),
                ),
              ),
              19.4.verticalSpace,
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
                            ..onTap = () => context.pushNamed(
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
