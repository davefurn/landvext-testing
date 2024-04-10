import 'package:landvext/src/core/constants/imports.dart';

class NoTransactionCard extends StatelessWidget {
  const NoTransactionCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          children: [
            Text(
              'No Transactions done yet',
              style: TextStyle(
                color: LandColors.inAppHint,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.28,
              ),
            ),
            50.verticalSpace,
          ],
        ),
      );
}
