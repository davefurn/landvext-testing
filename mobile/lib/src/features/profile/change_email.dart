import 'package:landvest/src/core/constants/imports.dart';

class ChangeEmailProfile extends StatefulWidget {
  const ChangeEmailProfile({Key? key}) : super(key: key);

  @override
  State<ChangeEmailProfile> createState() => _ChangeEmailProfileState();
}

class _ChangeEmailProfileState extends State<ChangeEmailProfile> {
  late TextEditingController email;
  bool submitted = false;
  final _formKey = GlobalKey<FormState>();
  LoadingState state = LoadingState.normal;

  @override
  void initState() {
    super.initState();
    email = TextEditingController();
  }

  Future<void> changeEmail() async {
    setState(() {
      state = LoadingState.loading;
    });
    // await PostRequest.changeEmail(
    //   context,
    //   confirmPassword: confirmController.text,
    //   password: passwordController.text,
    // );

    setState(() {
      state = LoadingState.normal;
    });
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          translate: 'Email',
          appBar: AppBar(),
          widget: const SizedBox.shrink(),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              50.verticalSpace,
              CustomTextInput(
                controller: email,
                autovalidateMode: submitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Enter your new email';
                  } else if (!LandConstants.emailRegEx.hasMatch(v)) {
                    return 'Enter valid email';
                  }
                  return null; // to indicate a success
                },
                hintText: 'Enter new email',
                keyboardType: TextInputType.emailAddress,
              ),
              16.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: LoadingButton(
                  state: state,
                  color: LandColors.mainColor,
                  width: double.maxFinite,
                  text: 'Change Email',
                  onTap: () {
                    setState(() => submitted = true);
                    if (_formKey.currentState!.validate()) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      changeEmail();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
