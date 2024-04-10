import 'package:intl/intl.dart';
import 'package:landvext/src/core/constants/imports.dart';

class DashBoardSavings extends StatelessWidget {
  const DashBoardSavings({
    required this.assetsI,
    required this.goal,
    required this.datePart,
    super.key,
  });

  final AssetImage assetsI;
  final double goal;
  final String datePart;

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
                ).format(goal),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 31.h,
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 8.h,
                ),
                margin: EdgeInsets.only(
                  left: 4.w,
                  right: 119.w,
                  bottom: 5.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: LandColors.backgroundColour.withOpacity(.10),
                ),
                child: Row(
                  children: [
                    Text(
                      'Withdrawal Date:',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      datePart,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
