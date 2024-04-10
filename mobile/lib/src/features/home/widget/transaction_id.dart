import 'package:landvext/src/core/constants/imports.dart';

class TransactionID extends StatelessWidget {
  const TransactionID({
    required this.text,
    super.key,
  });
  final String text;
  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Transaction ID:',
            style: TextStyle(
              color: LandColors.textColorNewGrey,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              height: 0,
              letterSpacing: -0.28,
            ),
          ),
          const SizedBox(width: 8),
          FittedBox(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: LandColors.textColorVeryBlack,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.28,
              ),
              maxLines: 2,
            ),
          ),
        ],
      );
}
