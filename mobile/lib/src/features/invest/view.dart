import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/features/invest/widget/grid_cards.dart';
import 'package:landvext/src/features/invest/widget/top_button.dart';

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
                      builder: (context) => TopButton(
                        selectedValue: selectedValue,
                        onchanged: (newValue) {
                          setState(() {
                            selectedValue = newValue!;
                          });
                        },
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
              const GridCards(),
            ],
          ),
          // const ComingSoonWidget(),
        ],
      ),
    );
  }
}
