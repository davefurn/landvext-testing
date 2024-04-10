import 'dart:async';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/services/postRequests/requests/email_sent.dart';
import 'package:landvext/src/features/authentication/forgotPassword/widgets/back_button.dart';
import 'package:landvext/src/features/authentication/widgets/text_input_emails.dart';

class SentEmail extends StatefulWidget {
  const SentEmail({super.key});

  @override
  State<SentEmail> createState() => _SentEmailState();
}

class _SentEmailState extends State<SentEmail> {
  final _formKey = GlobalKey<FormState>();

  bool submitted = false;
  LoadingState state = LoadingState.normal;
  late TextEditingController textEditingController;
  String currentText = '';
  int countdown = 60;
  bool timerActive = false;

  @override
  void initState() {
    super.initState();

    textEditingController = TextEditingController();
    // Start the countdown timer
    startTimer();
  }

  void startTimer() {
    setState(() {
      timerActive = true;
    });
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (timer) {
      if (mounted) {
        if (countdown == 0) {
          setState(() {
            timer.cancel();
            timerActive = false;
          });
        } else {
          setState(() {
            countdown--;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> emailSent() async {
    setState(() {
      state = LoadingState.loading;
    });

    await PostRequestEmailSent.emailSent(
      context,
      email: textEditingController.text,
    );

    setState(() {
      state = LoadingState.normal;
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BackButtonss(
            ontap: () {
              context.pop();
            },
          ),
          50.verticalSpace,
          Texts(
            text: translate('authentication:sent_email_title'),
            padding: 20.w,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 24.sp,
                  color: LandColors.textColorVeryBlack,
                  fontWeight: FontWeight.w700,
                ),
          ),
          20.verticalSpace,
          Padding(
            padding: EdgeInsets.only(right: 51.w),
            child: Texts(
              text: translate('authentication:sent_email_description'),
              padding: 20.w,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 14.sp,
                    color: LandColors.textColorVeryBlack,
                  ),
            ),
          ),
          25.verticalSpace,
          Form(
            key: _formKey,
            child: LoginEmailInput(
              emailController: textEditingController,
              translate: translate,
              submitted: submitted,
            ),
          ),
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

                  emailSent();
                }
              },
              text: translate('authentication:sent_email_button'),
            ),
          ),
          32.verticalSpace,
        ],
      ),
    );
  }
}
