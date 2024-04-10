import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/features/home/history/view_more.dart';

class Amount extends StatelessWidget {
  const Amount({
    required this.widget,
    required this.text,
    required this.text2,
    super.key,
    this.color,
  });

  final HistoryMore widget;
  final String text;
  final String text2;
  final Color? color;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
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
              color: color ?? LandColors.textColorVeryBlack,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.28,
            ),
          ),
        ],
      );
}
