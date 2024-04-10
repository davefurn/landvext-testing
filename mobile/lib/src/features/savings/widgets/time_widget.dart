import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvext/src/core/constants/imports.dart';

class TimeWidget extends StatelessWidget {
  const TimeWidget({
    required this.progress,
    required this.formattedDifference,
    super.key,
  });

  final double progress;
  final String formattedDifference;

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
                  LandAssets.clock,
                  width: 16.666667938232422.w,
                  height: 16.666667938232422.h,
                  colorFilter: ColorFilter.mode(
                    progress == 1.0 ? LandColors.green : LandColors.redActive,
                    BlendMode.srcIn,
                  ),
                ),
                2.horizontalSpace,
                Text(
                  'Time:',
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
                  formattedDifference,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: LandColors.textColorVeryBlack,
                  ),
                ),
                4.horizontalSpace,
                Text(
                  'remaining',
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
