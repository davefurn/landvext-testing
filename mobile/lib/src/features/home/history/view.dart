import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/core/riverpod/providers.dart';
import 'package:landvest/src/core/services/get_requests.dart';
import 'package:landvest/src/core/widgets/app_error.dart';
import 'package:landvest/src/features/home/model/model.dart';
import 'package:landvest/src/features/home/model/paginations_model.dart';
import 'package:landvest/src/features/home/widget/types_savings.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class History extends ConsumerStatefulWidget {
  const History({super.key});

  @override
  ConsumerState<History> createState() => _HistoryState();
}

class _HistoryState extends ConsumerState<History> {
  final SavingsHistoryPaginationModel savingsHistoryPaginationModel =
      SavingsHistoryPaginationModel();
  late RefreshController refreshController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    refreshController = RefreshController();
    setState(() {});
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          translate: 'Transaction History',
          appBar: AppBar(),
          widget: const SizedBox.shrink(),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              14.verticalSpace,
              Container(
                width: 294.w,
                margin: EdgeInsets.only(
                  left: 36.5.w,
                  right: 44.5.w,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 4.h,
                ),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF4F6F7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                child: Center(
                  child: TypeHistory(
                    onSelected: (value) {
                      setState(() {
                        currentIndex = value.index;
                      });
                    },
                  ),
                ),
              ),
              32.verticalSpace,
              if (currentIndex == 0)
                Consumer(
                  builder: (context, watch, child) {
                    final walletHistory = ref.watch(walletHistoryProvider);

                    return walletHistory.when(
                      data: (data) {
                        if (data?.statusCode == 200 && data != null) {
                          List<TransactionModel>? value =
                              (data.data['transactions'] as List)
                                  .map((e) => TransactionModel.fromJson(e))
                                  .toList();

                          return value.isNotEmpty
                              ? LayoutBuilder(
                                  builder: (context, constraints) => SizedBox(
                                    height: 600.h,
                                    child: ListView.builder(
                                      itemCount: value.length,
                                      itemBuilder: (context, index) {
                                        String originalDateString =
                                            value[index].dateCreated;

                                        // Parse the original string to DateTime
                                        DateTime originalDate =
                                            DateTime.parse(originalDateString);

                                        // Format the DateTime to the desired format
                                        String formattedDate =
                                            DateFormat('E MMM d, y')
                                                .format(originalDate);

                                        // Format the DateTime to the desired time format
                                        String formattedTime =
                                            DateFormat('hh:mm a')
                                                .format(originalDate);
                                        return InkWell(
                                          onTap: () {
                                            context.pushNamed(
                                              AppRoutes.historyMore.name,
                                              extra: value[index],
                                            );
                                          },
                                          child: Container(
                                            height: 72.h,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color:
                                                      LandColors.textColorHint,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        top: 5.h,
                                                      ),
                                                      child: CircleAvatar(
                                                        radius: 20.r,
                                                        backgroundColor: value[
                                                                        index]
                                                                    .transactionType ==
                                                                'CREDIT'
                                                            ? LandColors
                                                                .greenLightShade
                                                            : LandColors
                                                                .redLightShade,
                                                        child: SvgPicture.asset(
                                                          value[index].transactionType ==
                                                                  'CREDIT'
                                                              ? LandAssets
                                                                  .leftArrow
                                                              : LandAssets
                                                                  .rightArrow,
                                                        ),
                                                      ),
                                                    ),
                                                    8.horizontalSpace,
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          NumberFormat.currency(
                                                            symbol: '₦',
                                                            decimalDigits: 2,
                                                          ).format(
                                                            value[index].amount,
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 18.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: value[index]
                                                                        .transactionType ==
                                                                    'CREDIT'
                                                                ? LandColors
                                                                    .green
                                                                : LandColors
                                                                    .redActive,
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Text(
                                                          value[index].transactionType ==
                                                                  'CREDIT'
                                                              ? 'Credit to ${value[index].destination}'
                                                              : 'Debit to ${value[index].destination}',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
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
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: LandColors
                                                            .textColorGrey,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      formattedTime,
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: LandColors
                                                            .textColorGrey,
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
                              : SizedBox(
                                  height: 500.h,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      LandAssets.noTrans,
                                      width: 150.w,
                                      height: 170.h,
                                    ),
                                  ),
                                );
                        } else {
                          return Center(
                            child: AppErrorWidget(
                              errorData: data?.data,
                              errorCode: data?.statusCode,
                              retry: CustomButton(
                                onpressed: () => ref.refresh(
                                  walletHistoryProvider,
                                ),
                                thickLine: 1,
                                text: 'Retry',
                              ),
                            ),
                          );
                        }
                      },
                      loading: () => SizedBox(
                        height: 500.h,
                        child: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                      error: (error, trace) => const Center(
                        child: AppErrorWidget(),
                      ),
                    );
                  },
                )
              else if (currentIndex == 1)
                Consumer(
                  builder: (context, watch, child) {
                    var savingsHistory = ref.watch(
                      savingsHistoryProvider(savingsHistoryPaginationModel),
                    );

                    return savingsHistory.when(
                      data: (data) {
                        if (data?.statusCode == 200 && data != null) {
                          savingsHistoryPaginationModel.totalPages =
                              data.data!['total_pages'];
                          List<TransactionModel>? value =
                              (data.data['results'] as List)
                                  .map((e) => TransactionModel.fromJson(e))
                                  .toList();

                          return value.isNotEmpty
                              ? SizedBox(
                                  height: 600.h,
                                  child: SmartRefresher(
                                    controller: refreshController,
                                    enablePullUp: true,
                                    physics: const ClampingScrollPhysics(),
                                    onRefresh: () async {
                                      value.clear();
                                      setState(() {});
                                      savingsHistoryPaginationModel
                                        ..currentPage = 1
                                        ..totalPages = 100;
                                      var _ = await ref.refresh(
                                        savingsHistoryProvider(
                                          savingsHistoryPaginationModel,
                                        ).future,
                                      );
                                      refreshController.refreshCompleted();
                                    },
                                    onLoading: () async {
                                      if (value.length !=
                                          savingsHistoryPaginationModel
                                              .totalPages) {
                                        try {
                                          savingsHistoryPaginationModel
                                              .currentPage += 1;
                                          final a = await GetRequest
                                              .getAllSavingsTransaction(
                                            savingsHistoryPaginationModel,
                                          );
                                          var b = (a!.data!['results'] as List)
                                              .map(
                                                (e) =>
                                                    TransactionModel.fromJson(
                                                  e,
                                                ),
                                              )
                                              .toList();
                                          value.addAll(b);
                                          refreshController.loadComplete();
                                          setState(() {});
                                        } on Exception catch (_) {
                                          refreshController.refreshFailed();
                                        }
                                      } else {
                                        refreshController.loadNoData();
                                      }
                                    },
                                    child: LayoutBuilder(
                                      builder: (context, constraints) =>
                                          SizedBox(
                                        height: 600.h,
                                        child: ListView.builder(
                                          itemCount: value.length,
                                          itemBuilder: (context, index) {
                                            String originalDateString =
                                                value[index].dateCreated;

                                            // Parse the original string to DateTime
                                            DateTime originalDate =
                                                DateTime.parse(
                                              originalDateString,
                                            );

                                            // Format the DateTime to the desired format
                                            String formattedDate =
                                                DateFormat('E MMM d, y')
                                                    .format(originalDate);

                                            // Format the DateTime to the desired time format
                                            String formattedTime =
                                                DateFormat('hh:mm a')
                                                    .format(originalDate);
                                            return InkWell(
                                              onTap: () {
                                                context.pushNamed(
                                                  AppRoutes.historyMore.name,
                                                  extra: value[index],
                                                );
                                              },
                                              child: Container(
                                                height: 72.h,
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: LandColors
                                                          .textColorHint,
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            top: 5.h,
                                                          ),
                                                          child: CircleAvatar(
                                                            radius: 20.r,
                                                            backgroundColor: value[
                                                                            index]
                                                                        .transactionType ==
                                                                    'CREDIT'
                                                                ? LandColors
                                                                    .greenLightShade
                                                                : LandColors
                                                                    .redLightShade,
                                                            child: SvgPicture
                                                                .asset(
                                                              value[index].transactionType ==
                                                                      'CREDIT'
                                                                  ? LandAssets
                                                                      .leftArrow
                                                                  : LandAssets
                                                                      .rightArrow,
                                                            ),
                                                          ),
                                                        ),
                                                        8.horizontalSpace,
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              NumberFormat
                                                                  .currency(
                                                                symbol: '₦',
                                                                decimalDigits:
                                                                    2,
                                                              ).format(
                                                                value[index]
                                                                    .amount,
                                                              ),
                                                              style: TextStyle(
                                                                fontSize: 18.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: value[index]
                                                                            .transactionType ==
                                                                        'CREDIT'
                                                                    ? LandColors
                                                                        .green
                                                                    : LandColors
                                                                        .redActive,
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                              value[index].transactionType ==
                                                                      'CREDIT'
                                                                  ? 'Credit to ${value[index].destination}'
                                                                  : 'Debit to ${value[index].destination}',
                                                              style: TextStyle(
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
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
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          formattedDate,
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: LandColors
                                                                .textColorGrey,
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Text(
                                                          formattedTime,
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: LandColors
                                                                .textColorGrey,
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
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 500.h,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      LandAssets.noTrans,
                                      width: 150.w,
                                      height: 170.h,
                                    ),
                                  ),
                                );
                        } else {
                          return Center(
                            child: AppErrorWidget(
                              errorData: data?.data,
                              errorCode: data?.statusCode,
                              retry: CustomButton(
                                onpressed: () => ref.refresh(
                                  walletHistoryProvider,
                                ),
                                thickLine: 1,
                                text: 'Retry',
                              ),
                            ),
                          );
                        }
                      },
                      loading: () => SizedBox(
                        height: 500.h,
                        child: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                      error: (error, trace) => const Center(
                        child: AppErrorWidget(),
                      ),
                    );
                  },
                )
              else if (currentIndex == 2)
                SizedBox(
                  height: 500.h,
                  child: Center(
                    child: Image.asset(
                      LandAssets.comingSoon,
                      height: 150.h,
                      width: 151.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
}
