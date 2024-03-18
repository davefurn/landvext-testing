import 'package:landvest/src/core/constants/imports.dart';

class DialogBoxes extends StatelessWidget {
  const DialogBoxes({
    required this.icon,
    required this.text,
    required this.notButton,
    this.buttonOnePressed,
    this.buttonTwoPressed,
    this.buttonOneText,
    this.buttonTwoText,
    this.buttonTwoColor,
    super.key,
  });
  final Widget icon;
  final String text;
  final VoidCallback? buttonOnePressed;
  final bool notButton;
  final VoidCallback? buttonTwoPressed;
  final String? buttonOneText;
  final String? buttonTwoText;
  final Color? buttonTwoColor;
  @override
  Widget build(BuildContext context) => SimpleDialog(
        backgroundColor: LandColors.backgroundColour,
        // surfaceTintColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.r),
        ),
        title: icon,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: LandColors.textColorVeryBlack,
                  ),
                  textAlign: TextAlign.center,
                ),
                23.verticalSpace,
                if (notButton)
                  const SizedBox.shrink()
                else
                  Row(
                    children: [
                      CustomButton(
                        text: buttonOneText!,
                        onpressed: buttonOnePressed!,
                        thickLine: 1,
                        radius: 4.r,
                        width: 127.w,
                        height: 40.h,
                        hpD: 0.w,
                        fontWeight: FontWeight.w500,
                        borderColor: LandColors.inAppHint,
                        color: LandColors.transparent,
                        textcolor: LandColors.textColorVeryBlack,
                      ),
                      12.horizontalSpace,
                      CustomButton(
                        text: buttonTwoText!,
                        onpressed: buttonTwoPressed!,
                        thickLine: 1,
                        radius: 4.r,
                        width: 127.w,
                        height: 40.h,
                        hpD: 0.w,
                        fontWeight: FontWeight.w500,
                        borderColor: LandColors.transparent,
                        color: buttonTwoColor,
                        textcolor: LandColors.backgroundColour,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      );
}
