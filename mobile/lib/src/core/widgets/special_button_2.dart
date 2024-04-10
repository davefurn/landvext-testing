import 'package:landvext/src/core/constants/imports.dart';

class SpecialButton2 extends StatelessWidget {
  const SpecialButton2({
    required this.text,
    Key? key,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.selectedTextColor,
    this.icon,
    this.onTap,
    this.height,
    this.width,
  }) : super(key: key);
  final String text;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? selectedTextColor;
  final Widget? icon;
  final double? height;
  final double? width;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor ?? LandColors.textColorHint),
            color: backgroundColor ?? LandColors.backgroundColour,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
          // alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Row(
                  children: [
                    icon!,
                    6.horizontalSpace,
                  ],
                ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor ??
                      selectedTextColor ??
                      LandColors.textColorGrey,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      );
}
