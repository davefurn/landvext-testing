import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/riverpod/providers.dart';
import 'package:landvext/src/core/services/get_requests.dart';
import 'package:landvext/src/core/widgets/app_error.dart';
import 'package:landvext/src/features/home/history/services/all_history.dart';
import 'package:landvext/src/features/home/model/model.dart';
import 'package:landvext/src/features/home/model/paginations_model.dart';
import 'package:landvext/src/features/home/widget/savings_card_two.dart';
import 'package:landvext/src/features/home/widget/types_savings.dart';
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
                AllHistory(ref: ref)
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
                                          SavingsCards(value: value),
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
