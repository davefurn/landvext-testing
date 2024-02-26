import 'package:landvest/src/core/constants/imports.dart';

class BuyCard extends StatelessWidget {
  const BuyCard({
    required this.image,
    required this.title,
    required this.perUnit,
    required this.onpressed,
    required this.unitPrice,
    required this.location,
    super.key,
  });
  final String image;
  final String title;
  final String perUnit;
  final VoidCallback onpressed;
  final String unitPrice;
  final String location;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            children: [
              Container(
                height: 93.h,
                width: 104.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  image: DecorationImage(
                    image: AssetImage(
                      image,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              10.horizontalSpace,
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: LandColors.textColorVeryBlack,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: -0.32,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  4.verticalSpace,
                  Text(
                    location,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: LandColors.textColorGrey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      height: 0,
                      letterSpacing: -0.28,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  4.verticalSpace,
                  Text(
                    perUnit,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: LandColors.mainColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: -0.28,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  4.verticalSpace,
                  Text(
                    unitPrice,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: LandColors.textColorVeryBlack,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      letterSpacing: -0.40,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
          35.verticalSpace,
          CustomButton(
            radius: 4.r,
            borderColor: LandColors.transparent,
            color: LandColors.mainColor,
            textcolor: LandColors.backgroundColour,
            text: 'Make Payment',
            onpressed: onpressed,
            width: double.maxFinite,
            hpD: 0,
            thickLine: 1,
          ),
        ],
      );
}
