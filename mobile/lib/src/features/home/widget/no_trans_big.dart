import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvext/src/core/constants/imports.dart';

class NoTransBig extends StatelessWidget {
  const NoTransBig({
    super.key,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 500.h,
        child: Center(
          child: SvgPicture.asset(
            LandAssets.noTrans,
            width: 150.w,
            height: 170.h,
          ),
        ),
      );
}
