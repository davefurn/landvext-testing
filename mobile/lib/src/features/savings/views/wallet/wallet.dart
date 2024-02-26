import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/core/riverpod/providers.dart';
import 'package:landvest/src/core/services/get_requests.dart';
import 'package:landvest/src/core/widgets/app_error.dart';
import 'package:landvest/src/core/widgets/dialog_boxes.dart';
import 'package:landvest/src/core/widgets/view_all.dart';
import 'package:landvest/src/features/home/model/model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Wallet extends ConsumerStatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  ConsumerState<Wallet> createState() => _WalletState();
}

class _WalletState extends ConsumerState<Wallet> {
  late RefreshController refreshController;
  double initialAmount = 0;
  List<TransactionModel>? value;
  late AssetImage assetsI;
  @override
  void initState() {
    super.initState();
    refreshController = RefreshController();
    fetchData();
    assetsI = const AssetImage(
      LandAssets.home,
    );
  }

  Future<void> fetchData() async {
    try {
      String? currentBalances;
      currentBalances = await LocalStorage.instance.getCurrentBalance();
      initialAmount = double.parse(currentBalances.toString());

      setState(() {});
    } on Exception catch (error) {
      log('Error retrieving user data: $error');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(assetsI, context);
  }

  String formatValue(String rawValue) {
    final formattedValue = NumberFormat.currency(
      symbol: '₦',
      decimalDigits: 2,
    ).format(rawValue);

    return formattedValue;
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    final walletHistory = ref.watch(walletHistoryProvider);
    return Scaffold(
      appBar: CustomAppbar(
        backbutton: false,
        translate: 'Wallet',
        appBar: AppBar(),
        widget: const SizedBox.shrink(),
      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        physics: const ClampingScrollPhysics(),
        onRefresh: () async {
          value!.clear();
          setState(() {});
          final c = await GetRequest.getUserLoginCredentails();
          double newBalance = c!.data!['current_balance'];
          initialAmount = newBalance;
          var _ = ref.refresh(walletHistoryProvider);
          refreshController.refreshCompleted();
        },
        onLoading: () async {
          int paginationModel = 100;
          if (value!.length != paginationModel) {
            try {
              final a = await GetRequest.getAllUsersTransaction();
              var b = (a!.data!['transactions'] as List)
                  .map((e) => TransactionModel.fromJson(e))
                  .toList();
              value!.addAll(b);
              refreshController.loadComplete();
              setState(() {});
            } on Exception catch (_) {
              refreshController.refreshFailed();
            }
          } else {
            refreshController.loadNoData();
          }
        },
        child: ListView(
          children: [
            29.5.verticalSpace,
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
                    child: Text(
                      NumberFormat.currency(
                        symbol: '₦',
                        decimalDigits: 2,
                      ).format(initialAmount),
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            50.5.verticalSpace,
            ViewAll(
              textTile: translate('home:transactions'),
              subTextTile: 'View All',
              onTap: () {
                context.pushNamed(AppRoutes.history.name);
              },
            ),
            12.verticalSpace,
            walletHistory.when(
              data: (data) {
                if (data?.statusCode == 200 && data != null) {
                  // setState(() {
                  //   defaultValue = data.data['current_balance'];
                  // });
                  value = (data.data['transactions'] as List)
                      .map((e) => TransactionModel.fromJson(e))
                      .toList();

                  return value!.isNotEmpty
                      ? LayoutBuilder(
                          builder: (context, constraints) => SizedBox(
                            height: 300.h,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: value!.length,
                              itemBuilder: (context, index) {
                                String originalDateString =
                                    value![index].dateCreated;

                                // Parse the original string to DateTime
                                DateTime originalDate =
                                    DateTime.parse(originalDateString);

                                // Format the DateTime to the desired format
                                String formattedDate = DateFormat('E MMM d, y')
                                    .format(originalDate);

                                // Format the DateTime to the desired time format
                                String formattedTime =
                                    DateFormat('hh:mm a').format(originalDate);

                                return InkWell(
                                  onTap: () {
                                    context.pushNamed(
                                      AppRoutes.historyMore.name,
                                      extra: value![index],
                                    );
                                  },
                                  child: Container(
                                    height: 72.h,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: LandColors.textColorHint,
                                        ),
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12.h,
                                    ),
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 5.h),
                                              child: CircleAvatar(
                                                radius: 20.r,
                                                backgroundColor: value![index]
                                                            .transactionType ==
                                                        'CREDIT'
                                                    ? LandColors.greenLightShade
                                                    : LandColors.redLightShade,
                                                child: SvgPicture.asset(
                                                  value![index]
                                                              .transactionType ==
                                                          'CREDIT'
                                                      ? LandAssets.leftArrow
                                                      : LandAssets.rightArrow,
                                                ),
                                              ),
                                            ),
                                            8.horizontalSpace,
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  NumberFormat.currency(
                                                    symbol: '₦',
                                                    decimalDigits: 2,
                                                  ).format(
                                                    value![index].amount,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: value![index]
                                                                .transactionType ==
                                                            'CREDIT'
                                                        ? LandColors.green
                                                        : LandColors.redActive,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  value![index]
                                                              .transactionType ==
                                                          'CREDIT'
                                                      ? 'Credit to ${value![index].destination}'
                                                      : 'Debit to ${value![index].destination}',
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: LandColors
                                                        .textColorGrey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              formattedDate,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: LandColors.textColorGrey,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              formattedTime,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: LandColors.textColorGrey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : Center(
                          child: Column(
                            children: [
                              Text(
                                'No Transactions done yet',
                                style: TextStyle(
                                  color: LandColors.inAppHint,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.28,
                                ),
                              ),
                              50.verticalSpace,
                            ],
                          ),
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
            20.5.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  CustomButton(
                    text: 'Withdraw',
                    onpressed: () => showDialog(
                      context: context,
                      builder: (context) => DialogBoxes(
                        notButton: false,
                        icon: SvgPicture.asset(
                          LandAssets.alert,
                        ),
                        text: 'Are you sure you want to withdraw your wallet?',
                        buttonOnePressed: () {
                          context.pop();
                        },
                        buttonTwoPressed: () {
                          context
                            ..pop()
                            ..pushNamed(AppRoutes.withDrawal.name);
                        },
                        buttonOneText: 'Cancel',
                        buttonTwoText: 'Yes',
                        buttonTwoColor: LandColors.mainColor,
                      ),
                    ),
                    thickLine: 1,
                    radius: 4.r,
                    width: 162.5.w,
                    height: 48.h,
                    hpD: 0.w,
                    fontWeight: FontWeight.w500,
                    borderColor: LandColors.transparent,
                    color: LandColors.yellowButton,
                    textcolor: LandColors.yellowButtonText,
                  ),
                  10.horizontalSpace,
                  CustomButton(
                    text: 'Deposit',
                    onpressed: () {
                      context.goNamed(AppRoutes.walletDeposit.name);
                    },
                    thickLine: 1,
                    radius: 4.r,
                    width: 162.5.w,
                    height: 48.h,
                    hpD: 0.w,
                    fontWeight: FontWeight.w500,
                    borderColor: LandColors.transparent,
                    color: LandColors.mainColor,
                    textcolor: LandColors.backgroundColour,
                  ),
                ],
              ),
            ),
            50.verticalSpace,
          ],
        ),
      ),
    );
  }
}
