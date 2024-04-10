import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/widgets/dialog_boxes.dart';
import 'package:landvext/src/features/properties/model/model.dart';
import 'package:landvext/src/features/properties/widgets/dialog.dart';

class Sell extends StatelessWidget {
  const Sell({required this.propertiesModel, super.key});
  final PropertiesModel propertiesModel;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          translate: '',
          appBar: AppBar(),
          widget: const SizedBox.shrink(),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ),
          child: ListView(
            children: [
              10.verticalSpace,
              SizedBox(
                height: 225.h,
                width: double.maxFinite,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6.r),
                  ),
                  child: Image.asset(
                    propertiesModel.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              20.verticalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        propertiesModel.title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: LandColors.textColorVeryBlack,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        propertiesModel.location,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: LandColors.textColorNewGrey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  4.verticalSpace,
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 18.sp,
                        color: LandColors.textColorHintGrey,
                      ),
                      Text(
                        '1092',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: LandColors.textColorNewGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              40.verticalSpace,
              Container(
                decoration: BoxDecoration(
                  color: LandColors.quickLinksBlue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(4.r),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 10.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Bought: ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: LandColors.textColorNewGrey,
                        ),
                        children: [
                          TextSpan(
                            text: propertiesModel.cost,
                            style: TextStyle(
                              fontFamily: 'inter',
                              letterSpacing: -.2,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: LandColors.textColorVeryBlack,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    10.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Current value: ',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: LandColors.textColorNewGrey,
                            ),
                            children: [
                              TextSpan(
                                text: propertiesModel.sellingPrice,
                                style: TextStyle(
                                  fontFamily: 'inter',
                                  letterSpacing: -.2,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: LandColors.textColorVeryBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '+3%',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: LandColors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              40.verticalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DESCRIPTION',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: LandColors.textColorVeryBlack,
                    ),
                  ),
                  16.verticalSpace,
                  Text(
                    propertiesModel.description ?? '',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: LandColors.textColorVeryBlack,
                    ),
                    maxLines: 5,
                  ),
                ],
              ),
              40.verticalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GALLERY',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: LandColors.textColorVeryBlack,
                    ),
                  ),
                  12.verticalSpace,
                  SizedBox(
                    height: 72.h,
                    child: ListView.builder(
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.only(left: 8.w),
                        height: 72.h,
                        width: 72.h,
                        color: LandColors.textColorHint,
                      ),
                    ),
                  ),
                ],
              ),
              60.verticalSpace,
              CustomButton(
                radius: 4.r,
                borderColor: LandColors.redActive,
                thickLine: 1,
                color: LandColors.redActive,
                onpressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => DialogBoxes(
                      notButton: false,
                      icon: SvgPicture.asset(
                        LandAssets.alert,
                      ),
                      text: 'Are you sure you want to sell?',
                      buttonOnePressed: () {
                        context.pop();
                      },
                      buttonTwoPressed: () {
                        context.pop();
                        showDialog(
                          context: context,
                          builder: (context) => DialogBoxesSell(
                            notButton: false,
                            icon: SvgPicture.asset(
                              LandAssets.informationz,
                            ),
                            text:
                                'Your transaction will be completed within 24 hours',
                            buttonOnePressed: () {
                              context
                                ..pop()
                                ..pop();
                            },
                            buttonOneText: 'Back to My Properties',
                          ),
                        );
                      },
                      buttonOneText: 'Cancel',
                      buttonTwoText: 'Yes',
                      buttonTwoColor: LandColors.redActive,
                    ),
                  );
                },
                text: 'Sell',
                hpD: 0,
                textcolor: LandColors.backgroundColour,
              ),
              90.verticalSpace,
            ],
          ),
        ),
      );
}
