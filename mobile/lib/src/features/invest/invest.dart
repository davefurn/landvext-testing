import 'package:landvest/src/core/constants/imports.dart';

class EachInvestment extends StatelessWidget {
  const EachInvestment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          widget: const SizedBox.shrink(),
          translate: '',
          appBar: AppBar(),
        ),
        body: ListView(
          children: [
            Container(
              height: 230.h,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                image: const DecorationImage(
                  image: AssetImage(
                    LandAssets.defaultImage,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            20.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Capital City Estate',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: LandColors.textColorVeryBlack,
                          letterSpacing: -0.36,
                          height: 0,
                        ),
                      ),
                      8.verticalSpace,
                      Text(
                        'Cluster Omega, Jakarta',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: LandColors.textColorNewGrey,
                          height: 0,
                          letterSpacing: -0.28,
                        ),
                      ),
                    ],
                  ),
                  9.verticalSpace,
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 20.sp,
                        color: LandColors.textColorHintGrey,
                      ),
                      Text(
                        '1092 investors',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: LandColors.textColorNewGrey,
                          letterSpacing: -0.28,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                  27.verticalSpace,
                  Text(
                    '₦2,500,000',
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: LandColors.textColorVeryBlack,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: -0.48,
                    ),
                  ),
                ],
              ),
            ),
            22.5.verticalSpace,
            Container(
              width: double.maxFinite,
              height: 29.h,
              padding: EdgeInsets.only(
                top: 6.h,
                left: 22.84.w,
                right: 191.16.w,
                bottom: 6.h,
              ),
              decoration: const BoxDecoration(color: LandColors.yellowButton),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '24% Returns in 8 months',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: LandColors.ascentColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: -0.28,
                    ),
                  ),
                ],
              ),
            ),
            29.02.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'DESCRIPTION',
                  style: TextStyle(
                    color: LandColors.textColorVeryBlack,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    height: 0,
                    letterSpacing: -0.32,
                  ),
                ),
              ),
            ),
            12.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'Capital City Estate is a luxurious haven nestled in the heart of the bustling metropolis. This exclusive property offers an unparalleled urban living experience, combining contemporary design with the comfort of a suburban oasis. With its sleek architecture, stunning skyline views, and a myriad of amenities, Capital City Estate promises a lifestyle of sophistication and convenience. Explore the vibrant city life while coming home to the tranquility of this modern urban retreat. Your dream of city living awaits at Capital City Estate',
                style: TextStyle(
                  color: LandColors.textColorGrey,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            21.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'GALLERY',
                  style: TextStyle(
                    color: LandColors.textColorVeryBlack,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            12.77.verticalSpace,
            CustomButton(
              text: 'Invest',
              onpressed: () {
                context.goNamed(AppRoutes.buyInvestment.name);
              },
              thickLine: 1,
              radius: 4.r,
              width: double.maxFinite,
              height: 48.h,
              hpD: 20.w,
              fontWeight: FontWeight.w500,
              borderColor: LandColors.transparent,
              color: LandColors.mainColor,
              textcolor: LandColors.backgroundColour,
            ),
            100.verticalSpace,
          ],
        ),
      );
}
