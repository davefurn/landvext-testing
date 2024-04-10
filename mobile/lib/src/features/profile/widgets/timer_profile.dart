import 'package:landvext/src/core/constants/imports.dart';

class TimerProfile extends StatelessWidget {
  const TimerProfile({
    required this.translate,
    required this.timerActive,
    required this.countdown,
    super.key,
  });

  final TranslateType translate;
  final bool timerActive;
  final int countdown;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(
            translate('authentication:email_validation_timer'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: LandColors.textColorHintGrey,
                  fontSize: 15.978666305541992.sp,
                  fontWeight: FontWeight.w400,
                ),
          ),
          if (timerActive && countdown != 0)
            Text(
              countdown < 10 ? '00:0$countdown' : '00:$countdown',
              style: TextStyle(
                color: LandColors.textColorHintGrey,
                fontSize: 15.978666305541992.sp,
                fontWeight: FontWeight.w400,
              ),
            )
          else
            Text(
              '00:0$countdown',
              style: TextStyle(
                color: LandColors.textColorHintGrey,
                fontSize: 15.978666305541992.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      );
}
