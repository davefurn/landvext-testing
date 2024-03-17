import 'dart:async';

import 'package:landvest/src/core/constants/imports.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class DeleteOtp extends StatefulWidget {
  const DeleteOtp({super.key});

  @override
  State<DeleteOtp> createState() => _DeleteOtpState();
}

class _DeleteOtpState extends State<DeleteOtp> {
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

  Future<void> delete() async {
    setState(() {
      state = LoadingState.loading;
    });
    await PostRequest.deleteUser(
      context,
      otp: textEditingController.text,
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
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          translate: 'Delete',
          appBar: AppBar(),
          widget: const SizedBox.shrink(),
        ),
        extendBodyBehindAppBar: true,
        body: Form(
          key: _formKey,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                29.verticalSpace,
                Texts(
                  text: 'Delete Account',
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
                    "An otp was sent to your email[$email] for deletion of account, with deleting you will lose all your accounts etc and can't be retrieved until an update to policy",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: LandColors.textColorHintGrey,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                  ),
                ),
                50.verticalSpace,
                PinCodeTextField(
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
                24.verticalSpace,
                Padding(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                  ),
                  child: LoadingButton(
                    color: LandColors.mainColor,
                    state: state,
                    text: 'Delete',
                    onTap: () {
                      _formKey.currentState!.validate();
                      if (currentText == resetToken ||
                          textEditingController.text == resetToken) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        delete();
                      } else {
                        errorController.add(
                          ErrorAnimationType.shake,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
