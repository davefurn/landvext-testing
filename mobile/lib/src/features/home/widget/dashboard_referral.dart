import 'package:flutter_animate/flutter_animate.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/features/home/referral/referral.dart';
import 'package:landvext/src/features/home/widget/modal_sheet_referral.dart';

class DashBoardReferral extends StatelessWidget {
  const DashBoardReferral({
    required this.assetsI,
    required this.widget,
    super.key,
  });

  final AssetImage assetsI;
  final Referral widget;

  @override
  Widget build(BuildContext context) => Container(
        height: 167.h,
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: LandColors.transparent,
          image: DecorationImage(
            image: assetsI,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Referral coins',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: LandColors.backgroundColour,
                    ),
                  ),
                  Text(
                    widget.referralPoints,
                    style: TextStyle(
                      fontSize: 64.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: SizedBox(
                  height: 21.h,
                  child: CustomButton(
                    text: 'Info',
                    onpressed: () => showModalBottomSheet(
                      context: globalContext,
                      isScrollControlled: true,
                      builder: (context) => const ModalSheetReferral(),
                    ),
                    thickLine: 1,
                    radius: 50.r,
                    width: 75.w,
                    height: 21.h,
                    hpD: 7.5.w,
                    fontWeight: FontWeight.w500,
                    borderColor: LandColors.transparent,
                    color: LandColors.backgroundColour.withOpacity(.50),
                    textcolor: LandColors.backgroundColour,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
