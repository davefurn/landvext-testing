// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:landvest/src/core/constants/imports.dart';

class Deposit extends StatefulWidget {
  const Deposit({required this.id, Key? key}) : super(key: key);
  final String id;

  @override
  State<Deposit> createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  int selectedValue = 1;
  LoadingState state = LoadingState.normal;

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Scaffold(
      appBar: CustomAppbar(
        translate: '',
        appBar: AppBar(),
        widget: const SizedBox.shrink(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            34.6.verticalSpace,
            Text(
              'Payment methods',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: LandColors.textColorVeryBlack,
              ),
            ),
            16.verticalSpace,
            Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedValue = 1;
                    });
                  },
                  child: RadioListTile(
                    activeColor: LandColors.tileBlue,
                    selectedTileColor: LandColors.tileActiveShade,
                    selected: selectedValue == 1 ? true : false,
                    dense: true,
                    value: 1,
                    groupValue: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                    title: Row(
                      children: [
                        Text(
                          'Your wallet',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: LandColors.tileTextColor,
                          ),
                        ),
                        const Spacer(),
                        Image.asset(
                          'assets/images/icon/light_mode.jpg',
                          width: 19.w,
                          height: 25.h,
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: selectedValue == 1
                            ? LandColors.tileBlue
                            : LandColors.tileGrey,
                      ),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                12.verticalSpace,
                // InkWell(
                //   onTap: () {
                //     setState(() {
                //       selectedValue = 2;
                //     });
                //   },
                //   child: RadioListTile(
                //     activeColor: LandColors.tileBlue,
                //     selectedTileColor: LandColors.tileActiveShade,
                //     selected: selectedValue == 2 ? true : false,
                //     dense: true,
                //     value: 2,
                //     groupValue: selectedValue,
                //     onChanged: (value) {
                //       setState(() {
                //         selectedValue = value!;
                //       });
                //     },
                //     title: Row(
                //       children: [
                //         Text(
                //           'Card',
                //           style: TextStyle(
                //             fontSize: 14.sp,
                //             fontWeight: FontWeight.w400,
                //             color: LandColors.tileTextColor,
                //           ),
                //         ),
                //         const Spacer(),
                //         Image.asset(
                //           LandAssets.visa,
                //           width: 39.w,
                //           height: 12.h,
                //         ),
                //         16.horizontalSpace,
                //         Image.asset(
                //           LandAssets.mastercard,
                //           width: 26.w,
                //           height: 16.h,
                //         ),
                //       ],
                //     ),
                //     shape: RoundedRectangleBorder(
                //       side: BorderSide(
                //         color: selectedValue == 2
                //             ? LandColors.tileBlue
                //             : LandColors.tileGrey,
                //       ),
                //       borderRadius: BorderRadius.circular(4.r),
                //     ),
                //   ),
                // ),
                // 12.verticalSpace,
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedValue = 2;
                    });
                  },
                  child: RadioListTile(
                    activeColor: LandColors.tileBlue,
                    selectedTileColor: LandColors.tileActiveShade,
                    selected: selectedValue == 3 ? true : false,
                    dense: true,
                    value: 2,
                    groupValue: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                    title: Row(
                      children: [
                        Text(
                          'Bank Transfer',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: LandColors.tileTextColor,
                          ),
                        ),
                        const Spacer(),
                        Image.asset(
                          LandAssets.providus,
                          width: 17.w,
                          height: 20.h,
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: selectedValue == 2
                            ? LandColors.tileBlue
                            : LandColors.tileGrey,
                      ),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                12.verticalSpace,
                LoadingButton(
                  state: state,
                  color: LandColors.mainColor,
                  width: double.maxFinite,
                  text: translate(
                    'onboarding:text_onboarding_page_next',
                  ),
                  onTap: () async {
                    if (selectedValue == 1) {
                      await context.pushNamed(
                        AppRoutes.inputAmountDeposit.name,
                        pathParameters: {'id': widget.id},
                      );
                    } else if (selectedValue == 2) {
                      setState(() {
                        state = LoadingState.loading;
                      });
                      await PostRequest.createProvidus(
                        context,
                        id: int.tryParse(widget.id),
                      );
                      setState(() {
                        state = LoadingState.normal;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
