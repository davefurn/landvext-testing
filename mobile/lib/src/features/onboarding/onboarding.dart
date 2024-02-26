import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvest/src/core/constants/imports.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  late PageController _pageController;
  late List<AssetImage> assetsI;
  final ValueNotifier<double?> scollPositionNotifier = ValueNotifier(0);

  int currentIndex = 0;
  double opacity = 0;

  static const _kDuration = Duration(milliseconds: 500);
  static const _kCurve = Curves.ease;

  void nextPage() {
    _pageController.nextPage(duration: _kDuration, curve: _kCurve);
  }

  void previousPage() {
    _pageController.previousPage(duration: _kDuration, curve: _kCurve);
  }

  void _onScroll() {
    scollPositionNotifier.value = _pageController.page;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_onScroll);
    assetsI = [
      const AssetImage(
        LandAssets.onboardingPic1,
      ),
      const AssetImage(
        LandAssets.onboardingPic3,
      ),
      const AssetImage(
        LandAssets.onboardingPic2,
      ),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(assetsI[0], context);
    precacheImage(assetsI[1], context);
    precacheImage(assetsI[2], context);
  }

  void onChangedPage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Scaffold(
      extendBody: true,
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: onChangedPage,
        itemCount: 3,
        itemBuilder: (context, index) {
          List<String> title = [
            translate('onboarding:text_onboarding_page_one'),
            translate('onboarding:text_onboarding_page_two'),
            translate('onboarding:text_onboarding_page_three'),
          ];
          List<String> description = [
            translate('onboarding:text_onboarding_page_description_one'),
            translate('onboarding:text_onboarding_page_description_two'),
            translate('onboarding:text_onboarding_page_description_three'),
          ];
          return Container(
            height: double.maxFinite,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                image: assetsI[index],
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  const Color(0xff000000).withOpacity(0.8),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 77.6.h,
                  ).copyWith(bottom: 0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (index > 0)
                        InkWell(
                          onTap: previousPage,
                          child: SvgPicture.asset(
                            LandAssets.backTwo,
                          ),
                        )
                      else
                        SizedBox(
                          height: 47.936.h,
                          width: 47.936.w,
                        ),
                    ],
                  ),
                ),
                145.verticalSpace,
                SvgPicture.asset(LandAssets.logo).animate().fade(),
                125.verticalSpace,
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: WormEffect(
                    dotHeight: 4.565.h,
                    dotWidth: 45.10.w,
                    dotColor: LandColors.dotGrey.withOpacity(0.2),
                    activeDotColor: LandColors.mainColor,
                    spacing: 18.w,
                  ),
                  onDotClicked: (currentIndex) => _pageController.animateToPage(
                    currentIndex,
                    duration: _kDuration,
                    curve: _kCurve,
                  ),
                ),
                65.verticalSpace,
                Texts(
                  text: title[index],
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 27.392.sp,
                        color: LandColors.backgroundColour,
                        fontWeight: FontWeight.w500,
                      ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(),
                14.verticalSpace,
                Texts(
                  padding: 30.71.w,
                  text: description[index],
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 14.sp,
                        color: LandColors.backgroundColour.withOpacity(0.7),
                        fontWeight: FontWeight.w400,
                      ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(),
                70.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 22.83.w,
                  ),
                  child: CustomButton(
                    radius: 4.r,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: LandColors.mainColor,
                    textcolor: LandColors.backgroundColour,
                    width: double.maxFinite,
                    height: 54.784.h,
                    text: index == 2
                        ? translate(
                            'onboarding:text_onboarding_page_getstarted',
                          )
                        : translate(
                            'onboarding:text_onboarding_page_next',
                          ),
                    onpressed: index == 2
                        ? () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool(
                              LandConstants.hasOnBoarded,
                              true,
                            );

                            if (mounted) {
                              context.go(
                                AppRoutes.logIn.path,
                              );
                            }
                          }
                        : nextPage,
                    thickLine: 1,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
