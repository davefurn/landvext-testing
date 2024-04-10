import 'package:landvext/src/core/constants/imports.dart';

class ReceiptWidget extends StatelessWidget {
  const ReceiptWidget({
    required this.text1,
    required this.text2,
    super.key,
  });

  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text1,
              style: TextStyle(
                color: LandColors.textColorNewGrey,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                height: 0,
                letterSpacing: -0.28,
              ),
            ),
            8.horizontalSpace,
            Text(
              text2,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: LandColors.textColorVeryBlack,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.28,
              ),
            ),
          ],
        ),
      );
}
