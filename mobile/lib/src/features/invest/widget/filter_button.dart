import 'package:landvext/src/core/constants/imports.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sort,
              size: 20.sp,
              color: LandColors.peakBlack,
            ),
            12.horizontalSpace,
            Text(
              'Filter',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: LandColors.textColorVeryBlack,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                height: 0.06.h,
                letterSpacing: -0.40,
              ),
            ),
          ],
        ),
      );
}
