import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvest/src/core/constants/imports.dart';

class QuickLinks extends StatelessWidget {
  const QuickLinks({
    required this.icon,
    required this.text,
    required this.color,
    required this.onTap,
    super.key,
  });
  final String icon;
  final String text;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 94.w,
          child: Column(
            children: [
              Container(
                height: 44.h,
                width: 44.w,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(50.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 10.h,
                ),
                child: Center(
                  child: SvgPicture.asset(icon),
                ),
              ),
              12.verticalSpace,
              Text(
                text,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: LandColors.textColorGrey,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
      );
}
