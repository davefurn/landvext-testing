import 'package:intl/intl.dart';
import 'package:landvext/src/core/constants/imports.dart';

class DashboardWallet extends StatelessWidget {
  const DashboardWallet({
    required this.assetsI,
    required this.initialAmount,
    super.key,
  });

  final AssetImage assetsI;
  final double initialAmount;

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
              child: Text(
                NumberFormat.currency(
                  symbol: '₦',
                  decimalDigits: 2,
                ).format(initialAmount),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
}
