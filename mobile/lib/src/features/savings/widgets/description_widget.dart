import 'package:landvext/src/core/constants/imports.dart';

class DescriptionHub extends StatelessWidget {
  const DescriptionHub({
    required this.description,
    super.key,
  });

  final String? description;

  @override
  Widget build(BuildContext context) => Container(
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        decoration: BoxDecoration(
          color: LandColors.textColorHint,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: LandColors.textColorVeryBlack,
              ),
            ),
            16.verticalSpace,
            Text(
              description ?? 'Nothing',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: LandColors.textColorVeryBlack,
              ),
              maxLines: 2,
            ),
          ],
        ),
      );
}
