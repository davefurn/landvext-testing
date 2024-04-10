// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/services/postRequests/requests/create_wallet_providus.dart';

class WalletDeposit extends StatefulWidget {
  const WalletDeposit({Key? key}) : super(key: key);

  @override
  State<WalletDeposit> createState() => _WalletDepositState();
}

class _WalletDepositState extends State<WalletDeposit> {
  int selectedValue = 1;
  LoadingState state = LoadingState.normal;
  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Scaffold(
      appBar: CustomAppbar(
        translate: 'Deposit Funds',
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
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedValue = 2;
                    });
                  },
                  child: RadioListTile(
                    activeColor: LandColors.tileBlue,
                    selectedTileColor: LandColors.tileActiveShade,
                    selected: selectedValue == 2 ? true : false,
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
                    if (selectedValue == 2) {
                      setState(() {
                        state = LoadingState.loading;
                      });
                      await PostRequestCreateWalletProvidus
                          .createWalletProvidus(
                        context,
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
