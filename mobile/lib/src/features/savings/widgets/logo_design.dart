import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvext/src/core/constants/imports.dart';

class LogoDesign extends StatelessWidget {
  const LogoDesign({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
        height: 56.h,
        width: double.maxFinite,
        color: LandColors.ascentColor,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TRANSACTION RECEIPT',
              style: TextStyle(
                color: LandColors.backgroundColour,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.32,
              ),
            ),
            SvgPicture.asset(
              LandAssets.logoDesign,
              width: 36.w,
              height: 36.h,
            ),
          ],
        ),
      );
}
