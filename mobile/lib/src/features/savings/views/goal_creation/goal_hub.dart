import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/core/riverpod/providers.dart';
import 'package:landvest/src/core/services/get_requests.dart';
import 'package:landvest/src/core/widgets/dialog_boxes.dart';

import 'package:landvest/src/features/savings/model/goal.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GoalHub extends ConsumerStatefulWidget {
  const GoalHub({required this.goal, Key? key}) : super(key: key);
  final Goal goal;

  @override
  ConsumerState<GoalHub> createState() => _GoalHubState();
}

class _GoalHubState extends ConsumerState<GoalHub> {
  late AssetImage assetsI;
  List<Goal>? value;
  late RefreshController refreshController2;
  @override
  void initState() {
    super.initState();
    refreshController2 = RefreshController();
    setState(() {});

    assetsI = const AssetImage(
      LandAssets.savings,
    );
  }

  String formatValue(String rawValue) {
    StringBuffer formattedValue = StringBuffer();
    int length = rawValue.length;

    for (int i = 0; i < length; i++) {
      formattedValue.write(rawValue[i]);

      if ((length - i - 1) % 3 == 0 && i != length - 1) {
        formattedValue.write(',');
      }
    }
    if (formattedValue.length > 4) {
      String formattedString = formattedValue.toString();
      String newValue = formattedString.substring(0, formattedValue.length - 4);
      formattedValue = StringBuffer(newValue); // Update the StringBuffer
    }

    return formattedValue.toString();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(assetsI, context);
  }

  @override
  Widget build(BuildContext context) {
    String totalAmount = NumberFormat.currency(
      symbol: '₦',
      decimalDigits: 2,
    ).format(widget.goal.target);

    String currentAmount = NumberFormat.currency(
      symbol: '₦',
      decimalDigits: 2,
    ).format(widget.goal.currentBalance);

    double progress = widget.goal.currentBalance / widget.goal.target;

    double progresssss = progress * 100;

    String fullString = widget.goal.withdrawalDate;
    String datePart = fullString.substring(0, 10);
    DateTime dateTime = DateTime.parse(fullString);
    DateTime now = DateTime.now();
    Duration difference = dateTime.difference(now);
    String formatDuration(Duration duration) {
      // Calculate the difference in months and days
      int months = duration.inDays ~/ 31;
      int days = duration.inDays % 31;

      // Construct the formatted string
      String formattedString = '$months months $days days';
      return formattedString;
    }

    String formattedDifference = formatDuration(difference);

    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Scaffold(
      appBar: CustomAppbar(
        widget: const SizedBox.shrink(),
        translate: translate('savings:savings_title'),
        appBar: AppBar(),
      ),
      body: SmartRefresher(
        controller: refreshController2,
        enablePullUp: true,
        physics: const ClampingScrollPhysics(),
        onRefresh: () async {
          var _ = ref.refresh(goalsProvider);
          final a = await GetRequest.getAllSavings();

          for (final e in a!.data! as List) {
            if (e['id'] == widget.goal.id) {
              e['current_balance'] = widget.goal.currentBalance;
            }
          }

          refreshController2.refreshCompleted();
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Column(
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
                      child: Text(
                        NumberFormat.currency(
                          symbol: '₦',
                          decimalDigits: 2,
                        ).format(widget.goal.currentBalance),
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        height: 31.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 8.h,
                        ),
                        margin: EdgeInsets.only(
                          left: 4.w,
                          right: 119.w,
                          bottom: 5.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          color: LandColors.backgroundColour.withOpacity(.10),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Withdrawal Date:',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              datePart,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              11.verticalSpace,
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    context.pushNamed(AppRoutes.wallet.name);
                  },
                  child: Container(
                    width: 100.w,
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 5.h,
                    ),
                    margin: EdgeInsets.only(
                      right: 20.w,
                    ),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: LandColors.inAppHint,
                        ),
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          LandAssets.wallet,
                          colorFilter: const ColorFilter.mode(
                            LandColors.textColorVeryBlack,
                            BlendMode.srcIn,
                          ),
                        ),
                        10.horizontalSpace,
                        Text(
                          'Wallet',
                          style: TextStyle(
                            color: LandColors.textColorVeryBlack,
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              29.verticalSpace,
              LinearPercentIndicator(
                barRadius: Radius.circular(20.r),
                animation: true,
                lineHeight: 8.h,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                percent: progress > 1.0 ? 1.0 : progress,
                backgroundColor: LandColors.whiteGrey,
                progressColor:
                    progress == 1.0 ? LandColors.green : LandColors.ascentColor,
              ),
              4.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$currentAmount/$totalAmount',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: LandColors.textColorGrey,
                      ),
                    ),
                    Text(
                      '${progresssss.toStringAsFixed(10)}%',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: LandColors.textColorGrey,
                      ),
                    ),
                  ],
                ),
              ),
              34.verticalSpace,
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                decoration: BoxDecoration(
                  color: LandColors.textColorHint,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DESCRIPTION',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: LandColors.textColorVeryBlack,
                      ),
                    ),
                    16.verticalSpace,
                    Text(
                      widget.goal.shortDescription ?? 'Nothing',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: LandColors.textColorVeryBlack,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              12.verticalSpace,
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: LandColors.textColorHint,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          LandAssets.bulls,
                          width: 16.666667938232422.w,
                          height: 16.666667938232422.h,
                          colorFilter: ColorFilter.mode(
                            progress == 1.0
                                ? LandColors.green
                                : LandColors.redActive,
                            BlendMode.srcIn,
                          ),
                        ),
                        2.horizontalSpace,
                        Text(
                          'Target:',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: progress == 1.0
                                ? LandColors.green
                                : LandColors.redActive,
                          ),
                        ),
                      ],
                    ),
                    16.verticalSpace,
                    Row(
                      children: [
                        Text(
                          currentAmount,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: LandColors.textColorVeryBlack,
                          ),
                        ),
                        4.horizontalSpace,
                        Text(
                          'out of',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: LandColors.textGrey,
                          ),
                        ),
                        4.horizontalSpace,
                        Text(
                          totalAmount,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: LandColors.textColorVeryBlack,
                          ),
                        ),
                        4.horizontalSpace,
                        Text(
                          'saved',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: LandColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              12.verticalSpace,
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: LandColors.textColorHint,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          LandAssets.clock,
                          width: 16.666667938232422.w,
                          height: 16.666667938232422.h,
                          colorFilter: ColorFilter.mode(
                            progress == 1.0
                                ? LandColors.green
                                : LandColors.redActive,
                            BlendMode.srcIn,
                          ),
                        ),
                        2.horizontalSpace,
                        Text(
                          'Time:',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: progress == 1.0
                                ? LandColors.green
                                : LandColors.redActive,
                          ),
                        ),
                      ],
                    ),
                    16.verticalSpace,
                    Row(
                      children: [
                        Text(
                          formattedDifference,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: LandColors.textColorVeryBlack,
                          ),
                        ),
                        4.horizontalSpace,
                        Text(
                          'remaining',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: LandColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              42.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    CustomButton(
                      text: 'Withdraw',
                      onpressed: progress == 1.0
                          ? () => showDialog(
                                context: context,
                                builder: (context) => DialogBoxes(
                                  notButton: false,
                                  icon: SvgPicture.asset(
                                    LandAssets.alert,
                                  ),
                                  text:
                                      'Are you sure you want to withdraw your rent savings?',
                                  buttonOnePressed: () {
                                    context.pop();
                                  },
                                  buttonTwoPressed: () {
                                    context
                                      ..pop()
                                      ..pushNamed(
                                        AppRoutes.withdrawalSavings.name,
                                        pathParameters: {
                                          'amount': currentAmount,
                                          'surcharge': 'false',
                                        },
                                      );
                                  },
                                  buttonOneText: 'Cancel',
                                  buttonTwoText: 'Yes',
                                  buttonTwoColor: LandColors.mainColor,
                                ),
                              )
                          : () => showDialog(
                                context: context,
                                builder: (context) => DialogBoxes(
                                  notButton: false,
                                  icon: SvgPicture.asset(
                                    LandAssets.alert,
                                  ),
                                  text:
                                      'Your withdrawal date isn’t due yet. Withdrawing now will attract a 10% charge. Proceed?',
                                  buttonOnePressed: () {
                                    context.pop();
                                  },
                                  buttonTwoPressed: () {
                                    context
                                      ..pop()
                                      ..pushNamed(
                                        AppRoutes.withdrawalSavings.name,
                                        pathParameters: {
                                          'amount': currentAmount,
                                          'surcharge': 'true',
                                        },
                                      );
                                  },
                                  buttonOneText: 'Cancel',
                                  buttonTwoText: 'Yes',
                                  buttonTwoColor: LandColors.redActive,
                                ),
                              ),
                      thickLine: 1,
                      radius: 4.r,
                      width: 162.5.w,
                      height: 48.h,
                      hpD: 0.w,
                      fontWeight: FontWeight.w500,
                      borderColor: LandColors.transparent,
                      color: progress == 1.0
                          ? LandColors.yellowButton
                          : LandColors.textColorHint,
                      textcolor: progress == 1.0
                          ? LandColors.yellowButtonText
                          : LandColors.textColorGrey,
                    ),
                    10.horizontalSpace,
                    CustomButton(
                      text: 'Deposit',
                      onpressed: () {
                        context.pushNamed(
                          AppRoutes.deposit.name,
                          pathParameters: {'id': widget.goal.id.toString()},
                        );
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
              100.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
