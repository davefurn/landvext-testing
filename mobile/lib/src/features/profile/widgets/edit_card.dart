import 'package:landvext/src/core/constants/imports.dart';

class EditCard extends StatelessWidget {
  const EditCard({
    required this.mainText,
    required this.subText,
    required this.editable,
    this.onTap,
    super.key,
  });
  final String mainText;
  final String subText;
  final bool editable;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w).copyWith(
          bottom: 6.h,
        ),
        width: double.maxFinite,
        height: 70.h,
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: LandColors.backgroundColour,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: LandColors.textColorHint,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mainText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: LandColors.textColorVeryBlack,
                  ),
                ),
                Text(
                  subText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: LandColors.textColorGrey,
                  ),
                ),
              ],
            ),
            if (editable)
              Container(
                width: 50.w,
                height: 30.h,
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 1.h,
                ),
                margin: EdgeInsets.only(
                  right: 10.w,
                ),
                decoration: BoxDecoration(
                  color: LandColors.cardGrey,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Center(
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      color: LandColors.textColorVeryBlack,
                      fontSize: 12.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.28,
                    ),
                  ),
                ),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      );
}
