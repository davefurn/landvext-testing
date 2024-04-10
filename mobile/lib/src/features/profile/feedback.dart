import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/services/postRequests/requests/send_feedback.dart';

class FeedBacks extends StatefulWidget {
  const FeedBacks({super.key});

  @override
  State<FeedBacks> createState() => _FeedBacksState();
}

class _FeedBacksState extends State<FeedBacks> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController textEditingController;
  late TextEditingController textEditingController2;
  LoadingState state = LoadingState.normal;
  bool submitted = false;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    textEditingController2 = TextEditingController();
  }

  Future<void> sendFeedback() async {
    setState(() {
      state = LoadingState.loading;
    });
    await PostRequestSendFeedback.sendFeedback(
      context,
      title: textEditingController.text.trim(),
      message: textEditingController2.text.trim(),
    );
    setState(() {
      state = LoadingState.normal;
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    textEditingController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          widget: const SizedBox.shrink(),
          translate: 'Feedback & Help',
          appBar: AppBar(),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.only(
              top: 30.w,
            ),
            children: [
              CustomTextInput(
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return "Field can't be empty";
                  }

                  return null; // to indicate a success
                },
                autovalidateMode: submitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                hintText: 'What is it about? ',
                controller: textEditingController,
              ),
              16.sbH,
              CustomTextInput(
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return "Field can't be empty";
                  }

                  return null;
                },
                autovalidateMode: submitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                controller: textEditingController2,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                hintText: 'Enter content here? ',
                maxLines: 5,
                maxLength: 240,
              ),
              16.sbH,
              Padding(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                ),
                child: LoadingButton(
                  color: LandColors.mainColor,
                  state: state,
                  text: 'Send Feedback',
                  onTap: () {
                    setState(() => submitted = true);
                    if (_formKey.currentState!.validate()) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      sendFeedback();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
