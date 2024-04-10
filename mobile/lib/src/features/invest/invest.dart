import 'package:flutter/widgets.dart';
import 'package:landvext/src/core/constants/imports.dart';

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
            10.verticalSpace,
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
                ],
              ),
            ),
            22.5.verticalSpace,
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(
                vertical: 15.h,
                horizontal: 12.w,
              ),
              decoration: BoxDecoration(
                color: LandColors.yellowButton,
                borderRadius: BorderRadius.all(
                  Radius.circular(4.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '20/50 plots available',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: LandColors.textColorNewGrey,
                              letterSpacing: -0.28,
                              height: 0,
                            ),
                          ),
                          8.verticalSpace,
                          Text(
                            '₦2,300,000.00',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                              color: LandColors.textColorNewGrey,
                              height: 0,
                              letterSpacing: -0.28,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 32.h,
                        child: CustomButton(
                          text: 'Purchase',
                          onpressed: () {
                            context.pushNamed(AppRoutes.outright.name);
                          },
                          thickLine: 1,
                          radius: 50.r,
                          width: 110.w,
                          height: 32.h,
                          hpD: 0.w,
                          fontWeight: FontWeight.w400,
                          borderColor: LandColors.ascentColor,
                          color: LandColors.ascentColor,
                          textcolor: LandColors.backgroundColour,
                        ),
                      ),
                    ],
                  ),
                  15.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(AppRoutes.extend.name);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          size: 24.sp,
                          color: LandColors.textColorVeryBlack,
                        ),
                        2.horizontalSpace,
                        Text(
                          'View Survey Plan',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: LandColors.textColorVeryBlack,
                            letterSpacing: -0.28,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            14.verticalSpace,
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(
                vertical: 15.h,
                horizontal: 12.w,
              ),
              decoration: BoxDecoration(
                color: LandColors.quickLinksBlue,
                borderRadius: BorderRadius.all(
                  Radius.circular(4.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '20/100 units available',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: LandColors.textColorNewGrey,
                          letterSpacing: -0.28,
                          height: 0,
                        ),
                      ),
                      8.verticalSpace,
                      Text(
                        '₦300,000.00',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          color: LandColors.textColorNewGrey,
                          height: 0,
                          letterSpacing: -0.28,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 32.h,
                    child: CustomButton(
                      text: 'Co-own',
                      onpressed: () {
                        context.pushNamed(AppRoutes.coown.name);
                      },
                      thickLine: 1,
                      radius: 50.r,
                      width: 103.w,
                      height: 32.h,
                      hpD: 0.w,
                      fontWeight: FontWeight.w500,
                      borderColor: LandColors.mainColor,
                      color: LandColors.mainColor,
                      textcolor: LandColors.backgroundColour,
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
            10.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SizedBox(
                height: 72.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) => Container(
                    height: 72.h,
                    width: 72.w,
                    margin: EdgeInsets.only(
                      left: 10.w,
                    ),
                    decoration: BoxDecoration(
                      color: LandColors.textColorHint,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.r),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            50.verticalSpace,
          ],
        ),
      );
}
