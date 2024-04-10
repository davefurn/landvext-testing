import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvext/src/core/constants/imports.dart';

class BackButtonss extends StatelessWidget {
  const BackButtonss({
    required this.ontap,
    super.key,
  });
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 77.6.h,
        ).copyWith(bottom: 0.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: ontap,
              child: SvgPicture.asset(
                LandAssets.backThree,
              ),
            ),
            SizedBox(
              height: 47.936.h,
              width: 47.936.w,
            ),
          ],
        ),
      );
}
