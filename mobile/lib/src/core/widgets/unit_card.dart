import 'package:landvest/src/core/constants/imports.dart';

class UnitCard extends StatelessWidget {
  const UnitCard({
    required this.image,
    required this.title,
    required this.discount,
    required this.isGrid,
    super.key,
    this.unit,
    this.unitPrice,
    this.investors,
    this.numberInvestors,
  });
  final String image;
  final String title;
  final String discount;
  final bool isGrid;
  final String? unit;
  final String? unitPrice;
  final String? investors;
  final String? numberInvestors;
  @override
  Widget build(BuildContext context) => Container(
        height: double.maxFinite,
        width: isGrid ? 184.w : 170.w,
        margin: EdgeInsets.symmetric(
          horizontal: 6.w,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
          color: LandColors.backgroundColour,
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 117.h,
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.r)),
                image: DecorationImage(
                  image: AssetImage(
                    image,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            12.verticalSpace,
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: LandColors.textColorVeryBlack,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            4.verticalSpace,
            Text(
              discount,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: LandColors.textColorVeryBlack,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            4.verticalSpace,
            if (isGrid)
              SizedBox(
                width: 160.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          unitPrice!,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: LandColors.textColorVeryBlack,
                            fontFamily: '',
                          ),
                        ),
                        Text(
                          unit!,
                          style: TextStyle(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w400,
                            color: LandColors.textColorHint,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          numberInvestors!,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: LandColors.textColorVeryBlack,
                          ),
                        ),
                        Text(
                          investors!,
                          style: TextStyle(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w400,
                            color: LandColors.textColorHint,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      );
}
