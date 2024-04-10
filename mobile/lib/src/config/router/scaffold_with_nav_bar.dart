import 'dart:developer';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/riverpod/log_out.dart';

late BuildContext globalContext;

class ScaffoldWithNavBar extends ConsumerStatefulWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends ConsumerState<ScaffoldWithNavBar> {
  bool _shouldShowBottomNavBar() {
    // List of indices of base pages where BottomNavBar should be displayed
    // Adjust this list based on your specific base pages.
    final basePageIndices = [0, 1, 2, 3]; // Example base page indices

    // Check if the current page index is in the basePageIndices
    return basePageIndices.contains(widget.navigationShell.currentIndex);
  }

  @override
  void initState() {
    super.initState();
    globalContext = context;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(appSessionServiceProvider.notifier).countTime();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: SizedBox(
          height: 100,
          child: Builder(builder: (context) {
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
                          color: LandColors.scaffolddNavBar,
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
                              if (widget.navigationShell.currentIndex == 0)
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
                                  onTap: () => _onTap(context, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        LandAssets.homeIcon,
                                      ),
                                      Text(
                                        'Home',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: LandColors.textColorHintGrey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (widget.navigationShell.currentIndex == 1)
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
                                  onTap: () => _onTap(context, 1),
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
                                          color: LandColors.textColorHintGrey,
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
                              if (widget.navigationShell.currentIndex == 2)
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      LandAssets.investIconColored,
                                    ),
                                    Text(
                                      'Properties',
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
                                  onTap: () => _onTap(context, 2),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        LandAssets.investIcon,
                                      ),
                                      Text(
                                        'Properties',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: LandColors.textColorHintGrey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (widget.navigationShell.currentIndex == 3)
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
                                  onTap: () => _onTap(context, 3),
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
                                          color: LandColors.textColorHintGrey,
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
                          color: LandColors.backgroundColour.withOpacity(.1),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(pad),
                        child: CircleAvatar(
                          backgroundColor: LandColors.mainColor,
                          child: InkWell(
                            onTap: () {
                              context.goNamed(AppRoutes.wallet.name);
                            },
                            child: SvgPicture.asset(
                              LandAssets.wallet,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      );

  void _onTap(BuildContext context, int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}
