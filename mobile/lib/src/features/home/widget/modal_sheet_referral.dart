import 'package:landvext/src/core/constants/imports.dart';

class ModalSheetReferral extends StatelessWidget {
  const ModalSheetReferral({
    super.key,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * .5,
        child: Column(
          children: [
            Container(
              width: 47.979736328125.w,
              height: 5.3447265625.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.r),
                color: LandColors.dotGrey,
              ),
              margin: EdgeInsets.only(top: 7.92.h),
            ),
            28.63.verticalSpace,
            Text(
              'How to redeem your coins',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: LandColors.textColorVeryBlack,
              ),
            ),
            21.23.verticalSpace,
            Padding(
              padding: EdgeInsets.only(
                left: 21.94.w,
                right: 22.94.w,
              ),
              child: Text(
                "Enter the referral code provided to you by your friend or the person who referred you.Redeem Your Reward: Once the code is successfully entered, you'll receive your referral reward. This could be in the form of discounts, bonuses, or any other benefit offered by our app.Enjoy the Perks: You can now enjoy the perks or bonuses you've received from the referral. Be sure to check the terms and conditions associated with the referral offer to understand how it works.",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: LandColors.textColorGrey,
                  wordSpacing: -0.2,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      );
}
