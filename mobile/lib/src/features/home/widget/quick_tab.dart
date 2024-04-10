import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/features/home/widget/quick_links.dart';

class QuickLinksTab extends StatelessWidget {
  const QuickLinksTab({
    required this.widget,
    super.key,
  });

  final Home widget;

  @override
  Widget build(BuildContext context) => Container(
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 34.5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QuickLinks(
              color: LandColors.quickLinksGreen,
              icon: LandAssets.deposit,
              text: 'Deposit',
              onTap: () {
                context.pushNamed(
                  AppRoutes.walletDeposit.name,
                );
              },
            ),
            QuickLinks(
              color: LandColors.quickLinksYellow,
              icon: LandAssets.referralHome,
              text: 'Referrals',
              onTap: () {
                context.pushNamed(
                  AppRoutes.referral.name,
                  pathParameters: {
                    'referralPoint': widget.loginData.referralPoints.toString(),
                  },
                );
              },
            ),
            QuickLinks(
              color: LandColors.quickLinksBlue,
              icon: LandAssets.properties,
              text: 'Properties',
              onTap: () {
                context.pushNamed(AppRoutes.properties.name);
              },
            ),
          ],
        ),
      );
}

class Textss extends StatelessWidget {
  const Textss({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        child: Text(
          'Purchased Properties',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: LandColors.textColorVeryBlack,
          ),
        ),
      );
}
