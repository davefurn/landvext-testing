import 'package:landvext/src/core/constants/imports.dart';

class ItemsList extends StatelessWidget {
  const ItemsList({
    required this.text,
    required this.icon,
    super.key,
    this.backgroundColor,
    this.borderColor,
  });
  final Color? backgroundColor;
  final Color? borderColor;
  final String text;
  final Widget icon;

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w).copyWith(
          bottom: 6.h,
        ),
        width: double.maxFinite,
        height: 48.h,
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? LandColors.referralField,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: LandColors.textColorVeryBlack,
              ),
            ),
            icon,
          ],
        ),
      );
}
