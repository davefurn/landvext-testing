import 'package:landvest/src/core/constants/imports.dart';

class CardDeposit extends StatefulWidget {
  const CardDeposit({Key? key}) : super(key: key);

  @override
  State<CardDeposit> createState() => _CardDepositState();
}

class _CardDepositState extends State<CardDeposit> {
  late TextEditingController cardNumber;

  late TextEditingController cardHolderName;
  late TextEditingController expiryDate;
  late TextEditingController cv4;
  bool submitted = false;
  LoadingState state = LoadingState.normal;
  String displayText = '';
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    cardHolderName = TextEditingController();
    cardNumber = TextEditingController();
    expiryDate = TextEditingController();
    cv4 = TextEditingController();
  }

  @override
  void dispose() {
    cardHolderName.dispose();
    cardNumber.dispose();
    cv4.dispose();
    expiryDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          translate: 'Deposit',
          appBar: AppBar(),
          widget: const SizedBox.shrink(),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              32.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Card Number',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: LandColors.textColorVeryBlack,
                  ),
                ),
              ),
              8.verticalSpace,
              CustomTextInput(
                controller: cardNumber,
                hintText: 'Fill your card number',
                keyboardType: TextInputType.number,
                maxLength: 16,
              ),
              16.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Card Holder’s name',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: LandColors.textColorVeryBlack,
                  ),
                ),
              ),
              8.verticalSpace,
              CustomTextInput(
                onChanged: (p0) {
                  setState(() {
                    // Update the state when the text in the TextField changes
                    displayText = p0;
                  });
                },
                controller: cardHolderName,
                hintText: 'Card number name',
                keyboardType: TextInputType.name,
              ),
              16.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          'Expiry date',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: LandColors.textColorVeryBlack,
                          ),
                        ),
                      ),
                      8.verticalSpace,
                      CustomTextInput(
                        controller: expiryDate,
                        hintText: 'dd/mm/yyyy'.toUpperCase(),
                        keyboardType: TextInputType.number,
                        width: 159.w,
                        suffixIcon: IconButton(
                          splashColor: LandColors.transparent,
                          highlightColor: LandColors.transparent,
                          iconSize: 18.sp,
                          icon: const Icon(
                            Icons.calendar_month,
                            color: LandColors.textColorHintGrey,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          'CVV',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: LandColors.textColorVeryBlack,
                          ),
                        ),
                      ),
                      8.verticalSpace,
                      CustomTextInput(
                        controller: expiryDate,
                        hintText: ''.toUpperCase(),
                        keyboardType: TextInputType.number,
                        width: 159.w,
                      ),
                    ],
                  ),
                ],
              ),
              16.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                ),
                child: CustomButton(
                  radius: 4.r,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: LandColors.mainColor,
                  textcolor: LandColors.backgroundColour,
                  width: double.maxFinite,
                  height: 42.h,
                  text: 'Deposit',
                  onpressed: () {
                    context.goNamed(AppRoutes.inputAmountDeposit.name);
                  },
                  thickLine: 1,
                ),
              ),
            ],
          ),
        ),
      );
}
