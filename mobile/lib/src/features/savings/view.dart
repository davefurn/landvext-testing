// ignore_for_file: unnecessary_lambdas

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/core/riverpod/providers.dart';
import 'package:landvest/src/core/services/get_requests.dart';
import 'package:landvest/src/core/widgets/app_error.dart';
import 'package:landvest/src/features/savings/model/goal.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Savings extends ConsumerStatefulWidget {
  const Savings({Key? key}) : super(key: key);

  @override
  ConsumerState<Savings> createState() => _SavingsState();
}

class _SavingsState extends ConsumerState<Savings> {
  List<Goal>? value;

  late RefreshController refreshController;
  late RefreshController refreshController2;
  @override
  void initState() {
    super.initState();
    refreshController = RefreshController();
    refreshController2 = RefreshController();
    setState(() {});
  }

  @override
  void dispose() {
    refreshController.dispose();
    refreshController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goals = ref.watch(goalsProvider);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Scaffold(
      appBar: CustomAppbar(
        backbutton: false,
        widget: const SizedBox.shrink(),
        translate: translate('savings:savings_title'),
        appBar: AppBar(),
      ),
      floatingActionButton: goals.when(
        data: (data) {
          if (data?.statusCode == 200 && data != null) {
            value = (data.data as List).map((e) => Goal.fromJson(e)).toList();

            return value!.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(
                      bottom: 65.h,
                    ),
                    child: SizedBox(
                      height: 40.h,
                      child: CustomButton(
                        hasIcon: true,
                        text: 'Goal',
                        onpressed: () {
                          context.pushNamed(
                            AppRoutes.goalCreation.name,
                          );
                        },
                        thickLine: 1,
                        fontWeight: FontWeight.w500,
                        radius: 4.r,
                        width: 115.w,
                        height: 40.h,
                        borderColor: LandColors.ascentColor,
                        color: LandColors.ascentColor,
                        textcolor: LandColors.backgroundColour,
                        icon: Icon(
                          Icons.add,
                          size: 24.sp,
                          color: LandColors.backgroundColour,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          } else {
            return const SizedBox.shrink();
          }
        },
        loading: () => const SizedBox.shrink(),
        error: (error, trace) => const SizedBox.shrink(),
      ),
      body: goals.when(
        data: (data) {
          if (data?.statusCode == 200 && data != null) {
            value = (data.data as List).map((e) => Goal.fromJson(e)).toList();

            return value!.isNotEmpty
                ? Column(
                    children: [
                      Expanded(
                        child: SmartRefresher(
                          controller: refreshController,
                          enablePullUp: true,
                          physics: const ClampingScrollPhysics(),
                          onRefresh: () async {
                            value!.clear();
                            setState(() {});
                            //   paginationModel.page = 1;
                            //   paginationModel.total = 100;
                            var _ = ref.refresh(goalsProvider);
                            refreshController.refreshCompleted();
                          },
                          onLoading: () async {
                            int paginationModel = 100;
                            if (value!.length != paginationModel) {
                              try {
                                final a = await GetRequest.getAllSavings();
                                var b = (a!.data! as List)
                                    .map((e) => Goal.fromJson(e))
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
                          child: ListView.builder(
                            padding: EdgeInsets.only(
                              left: 20.w,
                              right: 20.w,
                              bottom: 100.h,
                            ),
                            itemCount: value!.length,
                            itemBuilder: (context, index) {
                              double totalAmount =
                                  value![index].target; // Total amount
                              double currentAmount = double.parse(
                                value![index].currentBalance.toString(),
                              ); // Current amount
                              double progress = currentAmount / totalAmount;
                              String fullString = value![index].withdrawalDate;
                              String datePart = fullString.substring(0, 10);
                              String progressss = progress.toStringAsFixed(2);

                              return InkWell(
                                onTap: () {
                                  context.pushNamed(
                                    AppRoutes.goalHub.name,
                                    extra: value![index],
                                  );
                                },
                                child: Container(
                                  width: 336.w,
                                  margin: EdgeInsets.symmetric(horizontal: 0.w)
                                      .copyWith(
                                    top: 20.h,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 16.h,
                                  ),
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        color: Color(0xFFE2E6EB),
                                      ),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        value![index].savingsType,
                                        style: TextStyle(
                                          color: LandColors.peakBlack,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      6.verticalSpace,
                                      LinearPercentIndicator(
                                        width: 250.w,
                                        trailing: Text(
                                          double.parse(progressss) > 1.0
                                              ? '100%'
                                              : '$progressss%',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color(0xFF64748B),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        barRadius: Radius.circular(20.r),
                                        animation: true,
                                        lineHeight: 8.h,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 2.w,
                                        ),
                                        percent: double.parse(progressss) > 1.0
                                            ? 1.0
                                            : double.parse(progressss),
                                        backgroundColor: LandColors.whiteGrey,
                                        progressColor: progress == 1.0
                                            ? LandColors.green
                                            : LandColors.ascentColor,
                                      ),
                                      6.verticalSpace,
                                      if (value![index].shortDescription !=
                                          null)
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'About:',
                                              style: TextStyle(
                                                color: const Color(0xFF363A43),
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              value![index].shortDescription!,
                                              style: TextStyle(
                                                color: const Color(0xFF363A43),
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        )
                                      else
                                        const SizedBox.shrink(),
                                      6.verticalSpace,
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Deposit Frequency:',
                                            style: TextStyle(
                                              color: const Color(0xFF363A43),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            value![index].depositFrequency,
                                            style: TextStyle(
                                              color: const Color(0xFF363A43),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      6.verticalSpace,
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Due:',
                                            style: TextStyle(
                                              color: const Color(0xFF363A43),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            datePart,
                                            style: TextStyle(
                                              color: const Color(0xFF363A43),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
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
                      90.verticalSpace,
                    ],
                  )
                : Center(
                    child: SmartRefresher(
                      controller: refreshController2,
                      enablePullUp: true,
                      physics: const ClampingScrollPhysics(),
                      onRefresh: () async {
                        value!.clear();
                        setState(() {});
                        //   paginationModel.page = 1;
                        //   paginationModel.total = 100;
                        var _ = ref.refresh(goalsProvider);
                        refreshController.refreshCompleted();
                      },
                      onLoading: () async {
                        int paginationModel = 100;
                        if (value!.length != paginationModel) {
                          try {
                            final a = await GetRequest.getAllSavings();
                            var b = (a!.data! as List)
                                .map((e) => Goal.fromJson(e))
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(LandAssets.target),
                          27.verticalSpace,
                          Text(
                            'You don’t have a goal yet',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: LandColors.inAppHint,
                            ),
                          ),
                          27.verticalSpace,
                          CustomButton(
                            hasIcon: true,
                            text: 'Create',
                            onpressed: () {
                              context.pushNamed(AppRoutes.goalCreation.name);
                            },
                            thickLine: 1,
                            radius: 50.r,
                            width: 131.w,
                            height: 32.h,
                            borderColor: LandColors.inAppHint,
                            color: LandColors.backgroundColour,
                            textcolor: LandColors.textColorVeryBlack,
                            icon: Icon(
                              Icons.add,
                              size: 20.sp,
                              color: LandColors.textColorVeryBlack,
                            ),
                          ),
                        ],
                      ),
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
        loading: () => Center(
          child: SizedBox(
            height: 35.h,
            width: 35.w,
            child: const CircularProgressIndicator.adaptive(),
          ),
        ),
        error: (error, trace) => const Center(
          child: AppErrorWidget(),
        ),
      ),
    );
  }
}
