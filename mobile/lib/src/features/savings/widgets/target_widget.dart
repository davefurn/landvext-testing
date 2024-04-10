import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvext/src/core/constants/imports.dart';

class TargetWidget extends StatelessWidget {
  const TargetWidget({
    required this.progress,
    required this.currentAmount,
    required this.totalAmount,
    super.key,
  });

  final double progress;
  final String currentAmount;
  final String totalAmount;

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: LandColors.textColorHint,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  LandAssets.bulls,
                  width: 16.666667938232422.w,
                  height: 16.666667938232422.h,
                  colorFilter: ColorFilter.mode(
                    progress == 1.0 ? LandColors.green : LandColors.redActive,
                    BlendMode.srcIn,
                  ),
                ),
                2.horizontalSpace,
                Text(
                  'Target:',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: progress == 1.0
                        ? LandColors.green
                        : LandColors.redActive,
                  ),
                ),
              ],
            ),
            16.verticalSpace,
            Row(
              children: [
                Text(
                  currentAmount,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: LandColors.textColorVeryBlack,
                  ),
                ),
                4.horizontalSpace,
                Text(
                  'out of',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: LandColors.textGrey,
                  ),
                ),
                4.horizontalSpace,
                Text(
                  totalAmount,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: LandColors.textColorVeryBlack,
                  ),
                ),
                4.horizontalSpace,
                Text(
                  'saved',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: LandColors.textGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
