import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/features/home/widget/ads_widget.dart';

class Invest extends StatefulWidget {
  const Invest({Key? key}) : super(key: key);

  @override
  State<Invest> createState() => _InvestState();
}

class _InvestState extends State<Invest> {
  String selectedValue = ' ';
  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Scaffold(
      appBar: CustomAppbar(
        widget: Padding(
          padding: EdgeInsets.only(right: 20.w),
          child: Icon(
            Icons.notifications_outlined,
            size: 24.sp,
          ),
        ),
        backbutton: false,
        translate: translate(
          'invest:invest_title',
        ),
        appBar: AppBar(),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              24.49.verticalSpace,
              Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  height: 32.h,
                  child: CustomButton(
                    text: 'Filter',
                    onpressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Container(
                          decoration: ShapeDecoration(
                            color: LandColors.backgroundColour,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.r),
                                topRight: Radius.circular(20.r),
                              ),
                            ),
                          ),
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height * .55,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              27.verticalSpace,
                              Align(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.sort,
                                      size: 20.sp,
                                      color: LandColors.peakBlack,
                                    ),
                                    12.horizontalSpace,
                                    Text(
                                      'Filter',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: LandColors.textColorVeryBlack,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                        height: 0.06.h,
                                        letterSpacing: -0.40,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              46.5.verticalSpace,
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 22.w),
                                  child: SizedBox(
                                    height: 32.h,
                                    child: CustomButton(
                                      radius: 50.r,
                                      width: 127.w,
                                      height: 32.h,
                                      borderColor: LandColors.inAppHint,
                                      text: 'Recently listed',
                                      textcolor: LandColors.textColorVeryBlack,
                                      onpressed: () {},
                                      thickLine: 1,
                                    ),
                                  ),
                                ),
                              ),
                              24.verticalSpace,
                              Padding(
                                padding: EdgeInsets.only(left: 22.w),
                                child: Text(
                                  'Categories',
                                  style: TextStyle(
                                    color: LandColors.textColorNewGrey,
                                    fontSize: 14.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                              ),
                              8.verticalSpace,
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 22.w),
                                child: Container(
                                  height: 42.h,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: LandColors.textColorHint,
                                    ),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 15.h,
                                  ).copyWith(right: 8.w),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      dropdownColor:
                                          LandColors.backgroundColour,
                                      iconSize: 24.sp,
                                      icon: SvgPicture.asset(
                                        LandAssets.arrowDown,
                                      ),
                                      isExpanded: true,
                                      menuMaxHeight: 150.h,
                                      elevation: 1,
                                      value: selectedValue,
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedValue = newValue!;
                                        });
                                      },
                                      items: [' ']
                                          .map<DropdownMenuItem<String>>(
                                            (value) => DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ),
                              24.verticalSpace,
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 22.w),
                                child: Text(
                                  'Price',
                                  style: TextStyle(
                                    color: LandColors.textColorNewGrey,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                              ),
                              8.verticalSpace,
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 22.w,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 48.h,
                                        child: CustomTextInput(
                                          keyboardType: TextInputType.number,
                                          hpD: 0.w,
                                          hintText: '',
                                        ),
                                      ),
                                    ),
                                    12.horizontalSpace,
                                    Container(
                                      width: 13.30.w,
                                      decoration: const ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            width: 2,
                                            strokeAlign:
                                                BorderSide.strokeAlignCenter,
                                            color: LandColors.textGrey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    12.horizontalSpace,
                                    Expanded(
                                      child: SizedBox(
                                        height: 48.h,
                                        child: CustomTextInput(
                                          keyboardType: TextInputType.number,
                                          hpD: 0.w,
                                          hintText: '',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              24.verticalSpace,
                              CustomButton(
                                text: 'Search result',
                                onpressed: () {
                                  context.goNamed(AppRoutes.walletDeposit.name);
                                },
                                thickLine: 1,
                                radius: 4.r,
                                width: double.maxFinite,
                                height: 48.h,
                                hpD: 22.w,
                                fontWeight: FontWeight.w500,
                                borderColor: LandColors.transparent,
                                color: LandColors.mainColor,
                                textcolor: LandColors.backgroundColour,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    thickLine: 1,
                    radius: 50.r,
                    width: 103.w,
                    height: 32.h,
                    hpD: 20.w,
                    fontWeight: FontWeight.w500,
                    borderColor: LandColors.inAppHint,
                    color: LandColors.backgroundColour,
                    textcolor: LandColors.textColorVeryBlack,
                    icon: Icon(
                      Icons.sort,
                      size: 20.sp,
                      color: LandColors.peakBlack,
                    ),
                  ),
                ),
              ),
              12.verticalSpace,
              Expanded(
                child: GridView.builder(
                  cacheExtent: 20,
                  padding: EdgeInsets.symmetric(horizontal: 5.5.w)
                      .copyWith(left: 15.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.8,
                    crossAxisCount: 2,
                    mainAxisSpacing: 11.h,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    List<String> images = [
                      LandAssets.product1,
                      LandAssets.product2,
                      LandAssets.product3,
                      LandAssets.product4,
                      LandAssets.product5,
                      LandAssets.product6,
                    ];

                    List<String> cost = [
                      'N1,000,000',
                      'N1,800,000',
                      'N1,000,000',
                      'N7,000,000',
                      'N2,500,000',
                      'N10,000,000',
                    ];

                    List<String> title = [
                      'Brook view cottage',
                      'Hilltop Residence',
                      'Land Banking Estate',
                      'Attitude Space Phase 2',
                      'Brook view cottage',
                      'Attitude Space Phase 1',
                    ];
                    List<String> location = [
                      'Ibusa, Delta',
                      'Leisure Park Asaba',
                      'Ibusa, Delta',
                      'Ibusa, Delta',
                      'Ibusa, Delta',
                      'Ibusa, Delta',
                    ];

                    return InkWell(
                      onTap: () {
                        context.goNamed(AppRoutes.eachInvestment.name);
                      },
                      child: GeneralCard(
                        comingSoon: false,
                        cost: cost[index],
                        discount: '+24% in 8m',
                        height: 224.h,
                        image: images[index],
                        location: location[index],
                        title: title[index],
                        totalInvestors: '1092',
                        width: 214.w,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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
          ),
        ],
      ),
    );
  }
}
