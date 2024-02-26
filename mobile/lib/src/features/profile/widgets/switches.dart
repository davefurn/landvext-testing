import 'package:landvest/src/core/constants/imports.dart';

class Switches extends StatelessWidget {
  const Switches({
    required this.fingerprintEnabled,
    required this.onchanged,
    required this.subText,
    super.key,
  });

  final bool fingerprintEnabled;
  final ValueChanged<bool>? onchanged;
  final String subText;

  @override
  Widget build(BuildContext context) => SwitchListTile(
        activeTrackColor: LandColors.mainColor,
        title: Row(
          children: [
            Icon(
              Icons.fingerprint,
              size: 32.sp,
              color: LandColors.ascentColor,
            ),
            20.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Use biometric',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: LandColors.textColorVeryBlack,
                  ),
                ),
                Text(
                  subText,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: LandColors.textColorNewGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
        value: fingerprintEnabled,
        onChanged: onchanged,
      );
}
