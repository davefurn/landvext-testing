import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvext/src/core/constants/imports.dart';

class AppBarHome extends StatelessWidget implements PreferredSizeWidget {
  const AppBarHome({
    required this.translate,
    required this.appBar,
    required this.name,
    super.key,
    this.backbutton = true,
    this.widget,
    this.backFunction,
  });

  final String translate;
  final AppBar appBar;
  final bool? backbutton;
  final Widget? widget;
  final VoidCallback? backFunction;
  final String name;

  @override
  Widget build(BuildContext context) => AppBar(
        backgroundColor: LandColors.backgroundColour,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w, top: 5.h),
          child: Row(
            children: [
              InkWell(
                onTap: () => context.goNamed(AppRoutes.profile.name),
                child: CircleAvatar(
                  radius: 17.5.r,
                  backgroundColor: LandColors.inAppHint,
                  child: Center(
                    child: Icon(
                      Icons.person,
                      color: LandColors.backgroundColour,
                      size: 28.sp,
                    ),
                  ),
                ),
              ),
              10.horizontalSpace,
              Text(
                'Hi, $name',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: LandColors.textColorVeryBlack,
                ),
              ),
            ],
          ),
        ),
        leadingWidth: 150.w,
        actions: [
          widget ??
              InkWell(
                child: Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: SvgPicture.asset(
                    LandAssets.info,
                    width: 25.w,
                    height: 25.h,
                  ),
                ),
              ),
        ],
        centerTitle: true,
      );

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
