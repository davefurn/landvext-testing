import 'package:landvext/src/core/constants/imports.dart';

class ButtonSavings extends StatelessWidget {
  const ButtonSavings({
    required this.text,
    required this.color,
    required this.textColor,
    super.key,
    this.width,
  });
  final String text;
  final Color color;
  final Color textColor;
  final double? width;

  @override
  Widget build(BuildContext context) => Container(
        height: 49.h,
        width: width ?? 189.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      );
}
