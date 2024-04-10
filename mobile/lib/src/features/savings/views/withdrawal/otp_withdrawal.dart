import 'dart:async';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/services/postRequests/requests/otp_withdrawal.dart';
import 'package:landvext/src/features/savings/views/withdrawal/model/receipt.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class WalletOtp extends StatefulWidget {
  const WalletOtp({
    required this.externalTrans,
    required this.route,
    super.key,
  });
  final String externalTrans;
  final String route;

  @override
  State<WalletOtp> createState() => _WalletOtpState();
}

class _WalletOtpState extends State<WalletOtp> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController textEditingController;
  late StreamController<ErrorAnimationType> errorController;
  String currentText = '';
  String email = '';
  LoadingState state = LoadingState.normal;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    errorController = StreamController<ErrorAnimationType>();
    LocalStorage.instance.getEmail().then((value) {
      email = '$value';
    });

    setState(() {});
  }

  Future<void> confirmWithdrawal() async {
    setState(() {
      state = LoadingState.loading;
    });
    BankTransaction bankTransaction =
        await LocalStorage.instance.getBankTransaction();
    await PostRequestRequestOtpWallet.requestOtpWallet(
      context,
      otp: textEditingController.text,
      externalTrans: widget.externalTrans,
      walletRoute: widget.route == 'true' ? true : false,
      bankTransaction: bankTransaction,
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
          translate: 'WithDrawal',
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
                  text: 'Withdrawal Confirmation',
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
                    "An otp was sent to your email $email for confirmation of withdrawal prcess",
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
                    text: 'Confirm',
                    onTap: () {
                      _formKey.currentState!.validate();
                      if (currentText == textEditingController.text) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        confirmWithdrawal();
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
