import 'package:landvext/src/core/constants/imports.dart';

class SubDashboard extends StatelessWidget {
  const SubDashboard({
    required this.subTextTitle,
    required this.subTextDescription,
    super.key,
  });
  final String subTextTitle;
  final String subTextDescription;

  @override
  Widget build(BuildContext context) => Container(
        width: 164.w,
        decoration: BoxDecoration(
          color: LandColors.backgroundColour.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8.r),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 12.h,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subTextTitle,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: LandColors.backgroundColour,
                  ),
            ),
            Text(
              subTextDescription,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: LandColors.backgroundColour,
                    fontFamily: '',
                  ),
            ),
          ],
        ),
      );
}
