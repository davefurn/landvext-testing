import 'dart:async';

import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/features/authentication/quickLogin/widget/numeric_keypad.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinTransact extends StatefulWidget {
  const PinTransact({super.key});

  @override
  State<PinTransact> createState() => _PinTransactState();
}

class _PinTransactState extends State<PinTransact> {
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
  }

  void inputNumber(int value) {
    if (textEditingController.text.length < 4) {
      textEditingController.text += value.toString();
    }
  }

  void clearLastInput() {
    if (textEditingController.text.isNotEmpty) {
      textEditingController.text = textEditingController.text.substring(
        0,
        textEditingController.text.length - 1,
      );
    }
  }

  void clearAll() {
    textEditingController.clear();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          widget: const SizedBox.shrink(),
          translate: 'WithDraw',
          appBar: AppBar(),
        ),
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  60.05.verticalSpace,
                  Align(
                    child: Text(
                      'Enter pin',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: LandColors.textColorVeryBlack,
                      ),
                    ),
                  ),
                  16.verticalSpace,
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
                      fieldHeight: 54.784.h,
                      fieldWidth: 54.784.w,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.r),
                      ),
                      borderWidth: 1,
                      fieldOuterPadding:
                          EdgeInsets.symmetric(horizontal: 4.595.w),
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
                  56.84.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26.82.w),
                    child: SizedBox(
                      width: 334.9998.w,
                      height: 292.18132.h,
                      child: NumericKeyPad(
                        signOut: false,
                        onTap: () {},
                        onInputNumber: inputNumber,
                        onClearLastInput: clearLastInput,
                        onClearAll: clearAll,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
