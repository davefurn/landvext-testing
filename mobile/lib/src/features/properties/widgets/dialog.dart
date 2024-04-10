import 'package:landvext/src/core/constants/imports.dart';

class DialogBoxesSell extends StatelessWidget {
  const DialogBoxesSell({
    required this.icon,
    required this.text,
    required this.notButton,
    this.buttonOnePressed,
    this.buttonOneText,
    super.key,
  });
  final Widget icon;
  final String text;
  final VoidCallback? buttonOnePressed;
  final bool notButton;

  final String? buttonOneText;

  @override
  Widget build(BuildContext context) => SimpleDialog(
        backgroundColor: LandColors.backgroundColour,
        // surfaceTintColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
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
                  CustomButton(
                    text: buttonOneText!,
                    onpressed: buttonOnePressed!,
                    thickLine: 1,
                    radius: 50.r,
                    width: 197.w,
                    height: 40.h,
                    hpD: 0.w,
                    fontWeight: FontWeight.w500,
                    borderColor: LandColors.inAppHint,
                    color: LandColors.transparent,
                    textcolor: LandColors.textColorVeryBlack,
                  ),
              ],
            ),
          ),
        ],
      );
}
