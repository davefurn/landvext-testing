import 'package:flutter_animate/flutter_animate.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/widgets/item_list.dart';
import 'package:landvext/src/features/invest/widget/custom_drop_down.dart';

class OutRightPurchase extends StatefulWidget {
  const OutRightPurchase({Key? key}) : super(key: key);

  @override
  State<OutRightPurchase> createState() => _OutRightPurchaseState();
}

class _OutRightPurchaseState extends State<OutRightPurchase> {
  int numbers = 0;
  LoadingState state = LoadingState.normal;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          widget: const SizedBox.shrink(),
          translate: 'OutRight Purchase',
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
                    LandAssets.survey,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    context.pushNamed(AppRoutes.extend.name);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.zoom_in_map,
                        size: 22.sp,
                        color: LandColors.peakBlack.withOpacity(.5),
                      ),
                      Text(
                        'Zoom',
                        style: TextStyle(
                          color: LandColors.peakBlack.withOpacity(.5),
                        ),
                      ),
                    ],
                  ),
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
                        'Select Plot',
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
                              'h1',
                              'h2',
                              'h3',
                              'h4',
                              'h5',
                              'h6',
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
                              'Select the plot you want to buy',
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
                                  numbers++;
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
            22.5.verticalSpace,
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  '$numbers Plots Selected',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: LandColors.textColorNewGrey,
                    fontStyle: FontStyle.italic,
                    height: 0,
                    letterSpacing: -0.28,
                  ),
                ),
              ),
            ),
            4.verticalSpace,
            SizedBox(
              height: 250.h,
              child: ListView.builder(
                itemCount: numbers,
                itemBuilder: (context, index) => ItemsList(
                  backgroundColor: LandColors.greyCard,
                  icon: IconButton(
                    color: LandColors.transparent,
                    highlightColor: LandColors.transparent,
                    icon: Icon(
                      Icons.close,
                      size: 20.sp,
                      color: LandColors.textColorVeryBlack,
                    ),
                    onPressed: () {
                      setState(() {
                        numbers--;
                      });
                    },
                  ),
                  text: 'h1',
                ).animate().shimmer(),
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
