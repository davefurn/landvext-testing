import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/widgets/dialog_boxes.dart';

class WithDrawButton extends StatelessWidget {
  const WithDrawButton({
    required this.progress,
    required this.currentAmount,
    required this.id,
    super.key,
  });

  final double progress;
  final String currentAmount;
  final int id;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            CustomButton(
              text: 'Withdraw',
              onpressed: progress == 1.0
                  ? () => showDialog(
                        context: context,
                        builder: (context) => DialogBoxes(
                          notButton: false,
                          icon: SvgPicture.asset(
                            LandAssets.alert,
                          ),
                          text:
                              'Are you sure you want to withdraw your rent savings?',
                          buttonOnePressed: () {
                            context.pop();
                          },
                          buttonTwoPressed: () {
                            context
                              ..pop()
                              ..pushNamed(
                                AppRoutes.withdrawalSavings.name,
                                pathParameters: {
                                  'amount': currentAmount,
                                  'surcharge': 'false',
                                  'id': id.toString(),
                                },
                              );
                          },
                          buttonOneText: 'Cancel',
                          buttonTwoText: 'Yes',
                          buttonTwoColor: LandColors.mainColor,
                        ),
                      )
                  : () => showDialog(
                        context: context,
                        builder: (context) => DialogBoxes(
                          notButton: false,
                          icon: SvgPicture.asset(
                            LandAssets.alert,
                          ),
                          text:
                              'Your withdrawal date isn’t due yet. Withdrawing now will attract a 10% charge. Proceed?',
                          buttonOnePressed: () {
                            context.pop();
                          },
                          buttonTwoPressed: () {
                            context
                              ..pop()
                              ..pushNamed(
                                AppRoutes.withdrawalSavings.name,
                                pathParameters: {
                                  'amount': currentAmount,
                                  'surcharge': 'true',
                                  'id': id.toString(),
                                },
                              );
                          },
                          buttonOneText: 'Cancel',
                          buttonTwoText: 'Yes',
                          buttonTwoColor: LandColors.redActive,
                        ),
                      ),
              thickLine: 1,
              radius: 4.r,
              width: 162.5.w,
              height: 48.h,
              hpD: 0.w,
              fontWeight: FontWeight.w500,
              borderColor: LandColors.transparent,
              color: progress == 1.0
                  ? LandColors.yellowButton
                  : LandColors.textColorHint,
              textcolor: progress == 1.0
                  ? LandColors.yellowButtonText
                  : LandColors.textColorGrey,
            ),
            10.horizontalSpace,
            CustomButton(
              text: 'Deposit',
              onpressed: () {
                context.pushNamed(
                  AppRoutes.deposit.name,
                  pathParameters: {'id': id.toString()},
                );
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
