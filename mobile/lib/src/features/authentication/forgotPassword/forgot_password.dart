import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/services/postRequests/requests/reset_password.dart';
import 'package:landvext/src/features/authentication/forgotPassword/widgets/back_button.dart';
import 'package:landvext/src/features/authentication/widgets/text_input_password.dart';

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
    await PostRequestResetPassword.resetPassword(
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
              BackButtonss(
                ontap: () {
                  context.pop();
                },
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
              LoginPasswordInput(
                submitted: submitted,
                translate: translate,
                passwordController: passwordController,
                isVisible: isVisible,
                onpressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
              ),
              12.verticalSpace,
              LoginPasswordInput(
                submitted: submitted,
                translate: translate,
                passwordController: confirmController,
                isVisible: isVisible,
                onpressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
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
                    if (_formKey.currentState!.validate() &&
                        confirmController.text == passwordController.text) {
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
