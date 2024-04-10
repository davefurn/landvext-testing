import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/functions/money_formatter.dart';
import 'package:landvext/src/features/invest/widget/filter_button.dart';

class TopButton extends StatefulWidget {
  const TopButton({
    required this.selectedValue,
    super.key,
    this.onchanged,
  });

  final String selectedValue;
  final void Function(String?)? onchanged;

  @override
  State<TopButton> createState() => _TopButtonState();
}

class _TopButtonState extends State<TopButton> {
  late TextEditingController firstSearchAmount;
  late TextEditingController secondSearchAmount;
  bool listed = true;
  bool invest = true;
  bool outRightPurchase = true;
  @override
  void initState() {
    super.initState();
    firstSearchAmount = TextEditingController();
    secondSearchAmount = TextEditingController();
  }

  @override
  void dispose() {
    firstSearchAmount.dispose();
    secondSearchAmount.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: ShapeDecoration(
          color: LandColors.backgroundColour,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
        ),
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * .68,
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                27.verticalSpace,
                const FilterButton(),
                46.5.verticalSpace,
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 22.w),
                    child: SizedBox(
                      height: 32.h,
                      child: CustomButton(
                        color: listed
                            ? LandColors.backgroundColour
                            : LandColors.mainColor,
                        fontSize: 10.sp,
                        radius: 50.r,
                        width: 119.w,
                        fontWeight: FontWeight.w400,
                        height: 32.h,
                        borderColor: listed
                            ? LandColors.inAppHint
                            : LandColors.mainColor,
                        text: 'Recently listed',
                        textcolor: listed
                            ? LandColors.textColorVeryBlack
                            : LandColors.backgroundColour,
                        onpressed: () {
                          setState(() {
                            listed = !listed;
                          });
                        },
                        thickLine: 1,
                      ),
                    ),
                  ),
                ),
                24.verticalSpace,
                Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 22.w),
                        child: SizedBox(
                          height: 32.h,
                          child: CustomButton(
                            color: invest
                                ? LandColors.backgroundColour
                                : LandColors.mainColor,
                            fontSize: 10.sp,
                            radius: 50.r,
                            width: 75.w,
                            fontWeight: FontWeight.normal,
                            height: 32.h,
                            textcolor: invest
                                ? LandColors.textColorVeryBlack
                                : LandColors.backgroundColour,
                            text: 'Invest',
                            borderColor: invest
                                ? LandColors.inAppHint
                                : LandColors.mainColor,
                            onpressed: () {
                              setState(() {
                                invest = !invest;
                              });
                            },
                            thickLine: 1,
                          ),
                        ),
                      ),
                    ),
                    4.horizontalSpace,
                    Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        height: 32.h,
                        child: CustomButton(
                          color: outRightPurchase
                              ? LandColors.backgroundColour
                              : LandColors.mainColor,
                          fontSize: 10.sp,
                          radius: 50.r,
                          width: 141.w,
                          textcolor: outRightPurchase
                              ? LandColors.textColorVeryBlack
                              : LandColors.backgroundColour,
                          fontWeight: FontWeight.normal,
                          height: 32.h,
                          borderColor: LandColors.inAppHint,
                          text: 'Outright Purchase',
                          onpressed: () {
                            setState(() {
                              outRightPurchase = !outRightPurchase;
                            });
                          },
                          thickLine: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                24.verticalSpace,
                Padding(
                  padding: EdgeInsets.only(left: 22.w),
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      color: LandColors.textColorNewGrey,
                      fontSize: 14.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
                8.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                  child: Container(
                    height: 42.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: LandColors.textColorHint,
                      ),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 15.h,
                    ).copyWith(right: 8.w),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: LandColors.backgroundColour,
                        iconSize: 24.sp,
                        icon: SvgPicture.asset(
                          LandAssets.arrowDown,
                        ),
                        isExpanded: true,
                        menuMaxHeight: 150.h,
                        elevation: 1,
                        value: widget.selectedValue,
                        onChanged: widget.onchanged,
                        items: [' ']
                            .map<DropdownMenuItem<String>>(
                              (value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
                24.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                  child: Text(
                    'Price',
                    style: TextStyle(
                      color: LandColors.textColorNewGrey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
                8.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 22.w,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48.h,
                          child: CustomTextInput(
                            hpD: 0.w,
                            hintText: '',
                            suffixText: 'NGN',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              MoneyTextFormatter(),
                            ],
                          ),
                        ),
                      ),
                      12.horizontalSpace,
                      Container(
                        width: 13.30.w,
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 2,
                              strokeAlign: BorderSide.strokeAlignCenter,
                              color: LandColors.textGrey,
                            ),
                          ),
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: SizedBox(
                          height: 48.h,
                          child: CustomTextInput(
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            hpD: 0.w,
                            hintText: '',
                            suffixText: 'NGN',
                            inputFormatters: [
                              MoneyTextFormatter(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                24.verticalSpace,
                CustomButton(
                  text: 'Search result',
                  onpressed: () {},
                  thickLine: 1,
                  radius: 4.r,
                  width: double.maxFinite,
                  height: 48.h,
                  hpD: 22.w,
                  fontWeight: FontWeight.w500,
                  borderColor: LandColors.transparent,
                  color: LandColors.mainColor,
                  textcolor: LandColors.backgroundColour,
                ),
                24.verticalSpace,
              ],
            ),
          ),
        ),
      );
}
