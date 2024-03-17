import 'package:landvest/src/core/constants/imports.dart';

class GeneralCardSold extends StatelessWidget {
  const GeneralCardSold({
    required this.height,
    required this.width,
    required this.image,
    required this.title,
    required this.location,
    required this.cost,
    required this.discount,
    required this.totalInvestors,
    required this.comingSoon,
    required this.pending,
    super.key,
    this.imageHeight,
    this.imageWidth,
    this.textPaddingHorizontal,
    this.textPaddingVertical,
  });
  final double height;
  final double width;
  final double? imageHeight;
  final double? imageWidth;
  final String image;
  final double? textPaddingHorizontal;
  final double? textPaddingVertical;
  final String title;
  final String location;
  final String cost;
  final String discount;
  final String totalInvestors;
  final bool comingSoon;
  final bool pending;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
        ),
        margin: EdgeInsets.only(
          right: 13.w,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 130.h,
                  width: double.maxFinite,
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 8.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: LandColors.textColorVeryBlack,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            location,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: LandColors.textColorNewGrey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cost,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: LandColors.textColorVeryBlack,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            height: 21.h,
                            width: 74.w,
                            decoration: BoxDecoration(
                              color: pending
                                  ? LandColors.quickLinksYellow
                                  : LandColors.quickLinksGreen,
                              borderRadius: BorderRadius.all(
                                Radius.circular(50.r),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                pending ? 'Pending' : 'Sold',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: pending
                                      ? LandColors.yellowDark
                                      : LandColors.green,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (comingSoon)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withOpacity(0.7),
                  child: Center(
                    child: Image.asset(
                      LandAssets.comingSoon,
                      height: 145.h,
                      width: 151.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      );
}
