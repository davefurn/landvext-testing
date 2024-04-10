import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvext/src/core/constants/imports.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({
    required this.ontap,
    required this.currentIndex,
    required this.navigationShell,
    Key? key,
  }) : super(key: key);
  final VoidCallback ontap;
  final int currentIndex;

  final StatefulNavigationShell navigationShell;

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  late int index;
  @override
  void initState() {
    setState(() {
      index = widget.currentIndex;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Builder(
              builder: (context) {
                double height = 93.h;
                double circleHeight = 64;
                double pad = 5;

                ///No touch
                double heightFactor =
                    (((height - (circleHeight / 2)) * 100) / height) / 100;
                return SizedBox(
                  height: height,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: circleHeight.h,
                          width: circleHeight.w,
                          padding: EdgeInsets.all(pad),
                          decoration: BoxDecoration(
                            color: LandColors.backgroundColour,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: LandColors.textColorVeryBlack,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: heightFactor,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: LandColors.backgroundColour,
                              border: Border.all(
                                color: LandColors.inAppHint,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.r),
                                topRight: Radius.circular(16.r),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ...[
                                  if (index == 0)
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(
                                          LandAssets.homeIconColored,
                                        ),
                                        Text(
                                          'Home',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: LandColors.mainColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ).animate().shake()
                                  else
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          index = 0;
                                        });
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          SvgPicture.asset(LandAssets.homeIcon),
                                          Text(
                                            'Home',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color:
                                                  LandColors.textColorHintGrey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (index == 1)
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(
                                          LandAssets.savingsIconColored,
                                          colorFilter: const ColorFilter.mode(
                                            LandColors.mainColor,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        Text(
                                          'Savings',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: LandColors.mainColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ).animate().shake()
                                  else
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          index = 1;
                                        });
                                        widget.navigationShell.goBranch(
                                          index,
                                          initialLocation: index ==
                                              widget
                                                  .navigationShell.currentIndex,
                                        );
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            LandAssets.savingsIcon,
                                          ),
                                          Text(
                                            'Savings',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color:
                                                  LandColors.textColorHintGrey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                                SizedBox(
                                  width: 30.w,
                                ),
                                ...[
                                  if (index == 2)
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(
                                          LandAssets.investIconColored,
                                        ),
                                        Text(
                                          'Invest',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: LandColors.mainColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ).animate().shake()
                                  else
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          index = 2;
                                        });
                                        widget.navigationShell.goBranch(
                                          index,
                                          initialLocation: index ==
                                              widget
                                                  .navigationShell.currentIndex,
                                        );
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            LandAssets.investIcon,
                                          ),
                                          Text(
                                            'Invest',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color:
                                                  LandColors.textColorHintGrey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (index == 3)
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(
                                          LandAssets.settingsIconColored,
                                        ),
                                        Text(
                                          'Settings',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: LandColors.mainColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ).animate().shake()
                                  else
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          index = 3;
                                        });
                                        widget.navigationShell.goBranch(
                                          index,
                                          initialLocation: index ==
                                              widget
                                                  .navigationShell.currentIndex,
                                        );
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            LandAssets.settingsIcon,
                                          ),
                                          Text(
                                            'Settings',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color:
                                                  LandColors.textColorHintGrey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: circleHeight.h,
                          width: circleHeight.w,
                          decoration: BoxDecoration(
                            color: LandColors.backgroundColour.withOpacity(.8),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  LandColors.backgroundColour.withOpacity(.1),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(pad),
                            child: CircleAvatar(
                              backgroundColor: LandColors.mainColor,
                              child: SvgPicture.asset(
                                LandAssets.wallet,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
}
