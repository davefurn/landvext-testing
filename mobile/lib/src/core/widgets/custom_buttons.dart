import 'package:landvext/src/core/constants/imports.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    required this.onpressed,
    required this.thickLine,
    super.key,
    this.hpD,
    this.color,
    this.textcolor,
    this.borderColor,
    this.fontWeight = FontWeight.w700,
    this.fontSize = 14,
    this.icon = const SizedBox.shrink(),
    this.disable = false,
    this.width,
    this.height,
    this.radius,
    this.hpV,
    this.spacingBetweenIconText = 8,
    this.hasIcon = false,
  });
  final FontWeight fontWeight;
  final double fontSize;
  final double? hpD;
  final double? hpV;
  final String text;
  final VoidCallback onpressed;
  final Color? color;
  final Color? textcolor;
  final Color? borderColor;
  final double thickLine;
  final Widget? icon;
  final bool disable;
  final double? width;
  final double? height;
  final double? radius;
  final double? spacingBetweenIconText;
  final bool? hasIcon;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: hpD ?? 0.w,
          vertical: hpV ?? 0.h,
        ),
        child: hasIcon!
            ? ElevatedButton.icon(
                icon: icon!,
                label: Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: textcolor ?? LandColors.backgroundColour,
                    fontWeight: fontWeight,
                  ),
                ),
                onPressed: onpressed,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  fixedSize: Size(width ?? 300.w, height ?? 48.h),
                  backgroundColor: disable ? Colors.grey : color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius ?? 8.r),
                  ),
                  side: BorderSide(
                    color: disable
                        ? Colors.grey
                        : borderColor ?? LandColors.mainColor,
                    width: thickLine,
                  ),
                ),
              )
            : ElevatedButton(
                onPressed: onpressed,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  fixedSize: Size(width ?? 300.w, height ?? 46.h),
                  backgroundColor: disable ? Colors.grey : color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius ?? 8.r),
                  ),
                  side: BorderSide(
                    color: disable
                        ? Colors.grey
                        : borderColor ?? LandColors.mainColor,
                    width: thickLine,
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize.sp,
                    color: textcolor ?? LandColors.backgroundColour,
                    fontWeight: fontWeight,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
      );
}
