import 'package:landvext/src/core/constants/imports.dart';

class ProfileWidgets extends StatelessWidget {
  const ProfileWidgets({
    required this.iconData,
    required this.text,
    required this.ontap,
    this.color,
    super.key,
  });

  final IconData iconData;
  final String text;
  final VoidCallback ontap;
  final Color? color;

  @override
  Widget build(BuildContext context) => SizedBox(
        child: InkWell(
          onTap: ontap,
          child: Row(
            children: [
              Icon(
                iconData,
                size: 24.sp,
                color: color ?? LandColors.textColorVeryBlack,
              ),
              12.horizontalSpace,
              Text(
                text,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: color ?? LandColors.textColorVeryBlack,
                ),
              ),
            ],
          ),
        ),
      );
}
