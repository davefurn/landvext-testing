import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/features/authentication/widgets/text_input_emails.dart';

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

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Scaffold(
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
            LoginEmailInput(
              translate: translate,
              submitted: submitted,
              emailController: email,
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
