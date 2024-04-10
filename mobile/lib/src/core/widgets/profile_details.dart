import 'package:landvext/src/core/constants/imports.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({
    required this.onpressed,
    required this.name,
    required this.number,
    required this.picture,
    super.key,
  });
  final VoidCallback onpressed;
  final String name;
  final String number;
  final String picture;

  @override
  Widget build(BuildContext context) => Container(
        width: double.maxFinite,
        height: 106.h,
        color: LandColors.mainColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28.r,
              backgroundImage: AssetImage(picture),
            ),
            12.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  number,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            44.horizontalSpace,
            InkWell(
              onTap: onpressed,
              child: Container(
                width: 94.w,
                height: 35.h,
                decoration: BoxDecoration(
                  color: LandColors.yellow,
                  borderRadius: BorderRadius.circular(40.r),
                ),
                child: Center(
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: LandColors.textColorBlack,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
