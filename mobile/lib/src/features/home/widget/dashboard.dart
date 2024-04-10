import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:landvext/src/core/constants/imports.dart';

class DashBoardHome extends StatelessWidget {
  const DashBoardHome({
    required this.assetsI,
    required this.isVisible,
    required this.currentBalance,
    required this.widget,
    required this.onpressed,
    super.key,
  });

  final AssetImage assetsI;
  final bool isVisible;
  final double currentBalance;
  final Home widget;
  final VoidCallback onpressed;

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
                isVisible
                    ? '******'
                    : NumberFormat.currency(
                        symbol: '₦',
                        decimalDigits: 2,
                      ).format(currentBalance),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ).animate().fade(),
            ),
            Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                height: 35.h,
                child: IconButton(
                  splashColor: LandColors.transparent,
                  highlightColor: LandColors.transparent,
                  iconSize: 20.sp,
                  icon: Icon(
                    isVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: LandColors.backgroundColour,
                  ),
                  onPressed: onpressed,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 35.h,
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 8.h,
                ),
                margin: EdgeInsets.only(
                  left: 119.w,
                  right: 4.w,
                  bottom: 5.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: LandColors.transparent,
                ),
                child: Text(
                  '${widget.loginData.firstName} ${widget.loginData.lastName}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.20,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
