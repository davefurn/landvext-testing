import 'package:landvext/src/core/constants/imports.dart';

class SuffixPercentage extends StatelessWidget {
  const SuffixPercentage({
    required this.currentAmount,
    required this.totalAmount,
    required this.progresssss,
    super.key,
  });

  final String currentAmount;
  final String totalAmount;
  final double progresssss;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$currentAmount/$totalAmount',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: LandColors.textColorGrey,
              ),
            ),
            Text(
              '${progresssss.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: LandColors.textColorGrey,
              ),
            ),
          ],
        ),
      );
}
