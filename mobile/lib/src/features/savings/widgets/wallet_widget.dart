import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvext/src/core/constants/imports.dart';

class WalletWidget extends StatelessWidget {
  const WalletWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 5.h,
        ),
        margin: EdgeInsets.only(
          right: 20.w,
        ),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: LandColors.inAppHint,
            ),
            borderRadius: BorderRadius.circular(50.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              LandAssets.wallet,
              colorFilter: const ColorFilter.mode(
                LandColors.textColorVeryBlack,
                BlendMode.srcIn,
              ),
            ),
            10.horizontalSpace,
            Text(
              'Wallet',
              style: TextStyle(
                color: LandColors.textColorVeryBlack,
                fontSize: 14.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                letterSpacing: -0.28,
              ),
            ),
          ],
        ),
      );
}
