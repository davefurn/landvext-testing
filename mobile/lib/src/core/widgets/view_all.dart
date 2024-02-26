import 'package:landvest/src/core/constants/imports.dart';

class ViewAll extends StatelessWidget {
  const ViewAll({
    required this.textTile,
    required this.subTextTile,
    required this.onTap,
    super.key,
    this.padding,
  });

  final String textTile;
  final String subTextTile;
  final VoidCallback onTap;
  final double? padding;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: padding ?? 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              textTile,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: LandColors.textColorVeryBlack,
              ),
            ),
            InkWell(
              onTap: onTap,
              child: Text(
                subTextTile,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: LandColors.textColorGrey,
                ),
              ),
            ),
          ],
        ),
      );
}
