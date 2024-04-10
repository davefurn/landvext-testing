import 'package:landvext/src/core/constants/imports.dart';

class ProfileAndName extends StatelessWidget {
  const ProfileAndName({
    required this.name,
    required this.phoneNumber,
    super.key,
  });

  final String name;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          left: 20.w,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26.731445.r,
              backgroundColor: LandColors.greyNewColor.withOpacity(.2),
              backgroundImage:
                  const AssetImage('assets/images/default/profile.png'),
            ),
            10.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: LandColors.textColorVeryBlack,
                  ),
                  textAlign: TextAlign.start,
                ),
                Text(
                  phoneNumber,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: LandColors.textColorGrey,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ],
        ),
      );
}
