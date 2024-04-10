import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/services/get_requests.dart';
import 'package:landvext/src/features/savings/model/goal.dart';
import 'package:landvext/src/features/savings/widgets/dashboard_savings.dart';
import 'package:landvext/src/features/savings/widgets/description_widget.dart';
import 'package:landvext/src/features/savings/widgets/suffix_percent.dart';
import 'package:landvext/src/features/savings/widgets/target_widget.dart';
import 'package:landvext/src/features/savings/widgets/time_widget.dart';
import 'package:landvext/src/features/savings/widgets/wallet_widget.dart';
import 'package:landvext/src/features/savings/widgets/withdraw_button.dart';
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
          final a =
              await GetRequest.getSpecificSavings(widget.goal.id.toString());
          setState(() {
            widget.goal.currentBalance = a!.data['current_balance'];
          });

          refreshController2.refreshCompleted();
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              18.verticalSpace,
              DashBoardSavings(
                assetsI: assetsI,
                goal: widget.goal.currentBalance,
                datePart: datePart,
              ),
              11.verticalSpace,
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    context.pushNamed(AppRoutes.wallet.name);
                  },
                  child: const WalletWidget(),
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
              SuffixPercentage(
                currentAmount: currentAmount,
                totalAmount: totalAmount,
                progresssss: progresssss,
              ),
              34.verticalSpace,
              DescriptionHub(
                description: widget.goal.shortDescription,
              ),
              12.verticalSpace,
              TargetWidget(
                progress: progress,
                currentAmount: currentAmount,
                totalAmount: totalAmount,
              ),
              12.verticalSpace,
              TimeWidget(
                progress: progress,
                formattedDifference: formattedDifference,
              ),
              42.verticalSpace,
              WithDrawButton(
                progress: progress,
                currentAmount: currentAmount,
                id: widget.goal.id,
              ),
              100.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
