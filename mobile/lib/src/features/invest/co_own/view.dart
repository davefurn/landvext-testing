import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/features/invest/widget/custom_drop_down.dart';

class CoOwn extends StatefulWidget {
  const CoOwn({Key? key}) : super(key: key);

  @override
  State<CoOwn> createState() => _CoOwnState();
}

class _CoOwnState extends State<CoOwn> {
  int numbers = 0;
  LoadingState state = LoadingState.normal;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          widget: const SizedBox.shrink(),
          translate: 'Co-Own',
          appBar: AppBar(),
        ),
        body: ListView(
          children: [
            10.verticalSpace,
            Container(
              height: 93.h,
              width: 104.w,
              margin: EdgeInsets.only(left: 20.w, right: 250.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                image: const DecorationImage(
                  image: AssetImage(
                    LandAssets.defaultImage,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            10.verticalSpace,
            Padding(
              padding: EdgeInsets.only(
                left: 20.w,
              ),
              child: Text(
                'Capital City Estate',
                textAlign: TextAlign.start,
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
            ),
            4.verticalSpace,
            Padding(
              padding: EdgeInsets.only(
                left: 20.w,
              ),
              child: Text(
                'Cluster Omega, Jakarta',
                textAlign: TextAlign.start,
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
            ),
            35.verticalSpace,
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
                color: LandColors.textColorHint,
                borderRadius: BorderRadius.all(
                  Radius.circular(4.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Units available: ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: LandColors.textColorVeryBlack,
                      ),
                      children: [
                        TextSpan(
                          text: '20/100',
                          style: TextStyle(
                            fontFamily: 'inter',
                            letterSpacing: -.2,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: LandColors.textColorVeryBlack,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  8.verticalSpace,
                  RichText(
                    text: TextSpan(
                      text: 'Investors: ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: LandColors.textColorVeryBlack,
                      ),
                      children: [
                        TextSpan(
                          text: '17',
                          style: TextStyle(
                            fontFamily: 'inter',
                            letterSpacing: -.2,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: LandColors.textColorVeryBlack,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            35.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select number of units',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: LandColors.textColorNewGrey,
                          height: 0,
                          letterSpacing: -0.28,
                        ),
                      ),
                      5.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomDropdown<int>(
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: LandColors.textColorVeryBlack,
                              size: 22.sp,
                            ),
                            onChange: (value, index) => print(value),
                            dropdownButtonStyle: DropdownButtonStyle(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              width: 244.w,
                              height: 42.h,
                              elevation: 0,
                              backgroundColor: LandColors.backgroundColour,
                              primaryColor: Colors.black87,
                              foregroundColor: LandColors.backgroundColour,
                              shadowColor: LandColors.backgroundColour,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: LandColors.textColorHint,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4.r),
                                ),
                              ),
                            ),
                            dropdownStyle: DropdownStyle(
                              color: LandColors.greyNewColor,
                              borderRadius: BorderRadius.circular(4.r),
                              elevation: 0,
                              padding: const EdgeInsets.all(5),
                            ),
                            items: [
                              '1',
                              '5',
                              '10',
                              '20',
                              '50',
                              '100',
                            ]
                                .asMap()
                                .entries
                                .map(
                                  (item) => DropdownItem<int>(
                                    value: item.key + 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        item.value,
                                        style: const TextStyle(
                                          color: LandColors.textColorVeryBlack,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            child: const Text(
                              'Number of units',
                              style: TextStyle(
                                color: LandColors.textColorVeryBlack,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40.h,
                            child: CustomButton(
                              text: 'Add',
                              onpressed: () {
                                setState(() {
                                  numbers += 10;
                                });
                              },
                              thickLine: 1,
                              fontWeight: FontWeight.w500,
                              radius: 4.r,
                              width: 83.w,
                              height: 42.h,
                              borderColor: LandColors.mainColor,
                              color: LandColors.mainColor,
                              textcolor: LandColors.backgroundColour,
                              icon: Icon(
                                Icons.add,
                                size: 24.sp,
                                color: LandColors.backgroundColour,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            150.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: RichText(
                text: TextSpan(
                  text: '$numbers units: ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: LandColors.textColorVeryBlack,
                  ),
                  children: [
                    TextSpan(
                      text: 'N9,500,000.00',
                      style: TextStyle(
                        fontFamily: 'inter',
                        letterSpacing: -.2,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: LandColors.textColorVeryBlack,
                      ),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            24.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: LoadingButton(
                state: state,
                onTap: () {
                  context.pushNamed(AppRoutes.buyInvestment.name);
                },
                text: 'Purchase',
                width: double.maxFinite,
              ),
            ),
            100.verticalSpace,
          ],
        ),
      );
}
