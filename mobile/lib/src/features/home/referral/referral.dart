import 'dart:developer';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/riverpod/providers.dart';
import 'package:landvext/src/core/widgets/app_error.dart';
import 'package:landvext/src/core/widgets/item_list.dart';
import 'package:landvext/src/features/home/referral/model/model.dart';
import 'package:landvext/src/features/home/widget/dashboard_referral.dart';

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
            DashBoardReferral(assetsI: assetsI, widget: widget),
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
