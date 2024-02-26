import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvest/src/core/constants/imports.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    required this.translate,
    required this.appBar,
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

  @override
  Widget build(BuildContext context) => AppBar(
        backgroundColor: LandColors.backgroundColour,
        title: Text(
          translate,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
        ),
        leading: backbutton!
            ? InkWell(
                onTap: backFunction ?? () => context.pop(),
                child: Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20.sp,
                  ),
                ),
              )
            : const SizedBox.shrink(),
        leadingWidth: 51.w,
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
