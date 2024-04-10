import 'package:landvext/src/core/constants/imports.dart';

class GridGeneralCard extends StatefulWidget {
  const GridGeneralCard({
    required this.height,
    required this.width,
    required this.image,
    required this.title,
    required this.location,
    required this.cost,
    required this.discount,
    required this.totalInvestors,
    required this.comingSoon,
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

  @override
  State<GridGeneralCard> createState() => _GridGeneralCardState();
}

class _GridGeneralCardState extends State<GridGeneralCard> {
  bool pressed = true;
  @override
  Widget build(BuildContext context) => Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          color: LandColors.cardGrey,
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
                    widget.image,
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
                            widget.title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: LandColors.textColorVeryBlack,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.location,
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
                      Text(
                        widget.cost,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: LandColors.mainColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.discount,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: LandColors.green,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 14.sp,
                                color: LandColors.textColorHintGrey,
                              ),
                              Text(
                                widget.totalInvestors,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: LandColors.textColorNewGrey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(right: 4.w, top: 6.h),
                child: CircleAvatar(
                  radius: 12.r,
                  backgroundColor: LandColors.backgroundColour.withOpacity(.5),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        pressed = !pressed;
                      });
                    },
                    splashColor: LandColors.redActive,
                    child: Center(
                      child: Icon(
                        pressed ? Icons.favorite_outline : Icons.favorite,
                        color: pressed
                            ? LandColors.backgroundColour
                            : LandColors.redActive,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (widget.comingSoon)
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
