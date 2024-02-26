import 'dart:developer';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/core/riverpod/providers.dart';
import 'package:landvest/src/core/widgets/app_error.dart';
import 'package:landvest/src/core/widgets/item_list.dart';
import 'package:landvest/src/features/home/referral/model/model.dart';

class Referral extends ConsumerStatefulWidget {
  const Referral({
    required this.referralPoints,
    Key? key,
  }) : super(key: key);
  final String referralPoints;

  @override
  ConsumerState<Referral> createState() => _ReferralState();
}

class _ReferralState extends ConsumerState<Referral> {
  late TextEditingController referralController;

  late AssetImage assetsI;
  List<ReferralModel>? value;
  String referralCode = '';
  @override
  void initState() {
    super.initState();

    assetsI = const AssetImage(
      LandAssets.referral,
    );

    referralController = TextEditingController(text: referralCode);
    _getReferralCode().whenComplete(
      () {
        referralController = TextEditingController(text: referralCode);
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(assetsI, context);
  }

  Future<void> _getReferralCode() async {
    try {
      LoginData referralCode = await LocalStorage.instance.getUserData();
      setState(() {
        this.referralCode = referralCode.referralCode;
      });
    } on Exception catch (e) {
      // Handle exceptions, if any
      log('Error getting referral code: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final referrals = ref.watch(referralProvider);

    return Scaffold(
      appBar: CustomAppbar(
        widget: const SizedBox.shrink(),
        translate: 'Referral',
        appBar: AppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            18.verticalSpace,
            Container(
              height: 167.h,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: LandColors.transparent,
                image: DecorationImage(
                  image: assetsI,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total Referral coins',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: LandColors.backgroundColour,
                          ),
                        ),
                        Text(
                          widget.referralPoints,
                          style: TextStyle(
                            fontSize: 64.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: SizedBox(
                        height: 21.h,
                        child: CustomButton(
                          text: 'Info',
                          onpressed: () => showModalBottomSheet(
                            context: globalContext,
                            isScrollControlled: true,
                            builder: (context) => SizedBox(
                              width: double.maxFinite,
                              height: MediaQuery.of(context).size.height * .5,
                              child: Column(
                                children: [
                                  Container(
                                    width: 47.979736328125.w,
                                    height: 5.3447265625.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.r),
                                      color: LandColors.dotGrey,
                                    ),
                                    margin: EdgeInsets.only(top: 7.92.h),
                                  ),
                                  28.63.verticalSpace,
                                  Text(
                                    'How to redeem your coins',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                      color: LandColors.textColorVeryBlack,
                                    ),
                                  ),
                                  21.23.verticalSpace,
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 21.94.w,
                                      right: 22.94.w,
                                    ),
                                    child: Text(
                                      "Enter the referral code provided to you by your friend or the person who referred you.Redeem Your Reward: Once the code is successfully entered, you'll receive your referral reward. This could be in the form of discounts, bonuses, or any other benefit offered by our app.Enjoy the Perks: You can now enjoy the perks or bonuses you've received from the referral. Be sure to check the terms and conditions associated with the referral offer to understand how it works.",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: LandColors.textColorGrey,
                                        wordSpacing: -0.2,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          thickLine: 1,
                          radius: 50.r,
                          width: 75.w,
                          height: 21.h,
                          hpD: 7.5.w,
                          fontWeight: FontWeight.w500,
                          borderColor: LandColors.transparent,
                          color: LandColors.backgroundColour.withOpacity(.50),
                          textcolor: LandColors.backgroundColour,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            33.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'Referral code',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: LandColors.textColorNewGrey,
                ),
              ),
            ),
            8.verticalSpace,
            Padding(
              padding: EdgeInsets.only(right: 153.w),
              child: CustomTextInput(
                controller: referralController,
                focusedBorder: LandColors.ascentColor,
                hintText: 'Referral Code',
                suffixIcon: IconButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: referralController.text),
                    );
                  },
                  icon: Icon(
                    Icons.copy,
                    size: 24.sp,
                    color: LandColors.ascentColor,
                  ),
                ),
              ),
            ),
            40.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'My Referrals',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: LandColors.textColorVeryBlack,
                ),
              ),
            ),
            18.verticalSpace,
            referrals.when(
              data: (data) {
                if (data?.statusCode == 200 && data != null) {
                  value = (data.data as List)
                      .map((e) => ReferralModel.fromJson(e))
                      .toList();

                  return value!.isNotEmpty
                      ? LayoutBuilder(
                          builder: (context, constraints) => SizedBox(
                            height: 300.h,
                            child: ListView.builder(
                              itemCount: value!.length,
                              itemBuilder: (context, index) => ItemsList(
                                icon: SvgPicture.asset(LandAssets.coin),
                                text:
                                    '${value![index].referred.firstName} ${value![index].referred.lastName}',
                              ).animate().shimmer(),
                            ),
                          ),
                        )
                      : Center(
                          child: ItemsList(
                            icon: SvgPicture.asset(LandAssets.coin),
                            text: 'No referral',
                          ).animate().shimmer(),
                        );
                } else {
                  return Center(
                    child: AppErrorWidget(
                      errorData: data?.data,
                      errorCode: data?.statusCode,
                      retry: CustomButton(
                        thickLine: 1,
                        text: 'Retry',
                        onpressed: () => ref.refresh(
                          goalsProvider,
                        ),
                      ),
                    ),
                  );
                }
              },
              loading: () => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              error: (error, trace) => const Center(
                child: AppErrorWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
