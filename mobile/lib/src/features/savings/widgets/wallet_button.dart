import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/widgets/dialog_boxes.dart';

class WalletButton extends StatelessWidget {
  const WalletButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            CustomButton(
              text: 'Withdraw',
              onpressed: () => showDialog(
                context: context,
                builder: (context) => DialogBoxes(
                  notButton: false,
                  icon: SvgPicture.asset(
                    LandAssets.alert,
                  ),
                  text: 'Are you sure you want to withdraw your wallet?',
                  buttonOnePressed: () {
                    context.pop();
                  },
                  buttonTwoPressed: () {
                    context
                      ..pop()
                      ..pushNamed(AppRoutes.withDrawal.name);
                  },
                  buttonOneText: 'Cancel',
                  buttonTwoText: 'Yes',
                  buttonTwoColor: LandColors.mainColor,
                ),
              ),
              thickLine: 1,
              radius: 4.r,
              width: 162.5.w,
              height: 48.h,
              hpD: 0.w,
              fontWeight: FontWeight.w500,
              borderColor: LandColors.transparent,
              color: LandColors.yellowButton,
              textcolor: LandColors.yellowButtonText,
            ),
            10.horizontalSpace,
            CustomButton(
              text: 'Deposit',
              onpressed: () {
                context.goNamed(AppRoutes.walletDeposit.name);
              },
              thickLine: 1,
              radius: 4.r,
              width: 162.5.w,
              height: 48.h,
              hpD: 0.w,
              fontWeight: FontWeight.w500,
              borderColor: LandColors.transparent,
              color: LandColors.mainColor,
              textcolor: LandColors.backgroundColour,
            ),
          ],
        ),
      );
}
