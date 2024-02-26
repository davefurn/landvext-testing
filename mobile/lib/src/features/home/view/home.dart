import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/core/riverpod/providers.dart';
import 'package:landvest/src/core/services/get_requests.dart';
import 'package:landvest/src/core/widgets/app_error.dart';
import 'package:landvest/src/core/widgets/appbar_home.dart';
import 'package:landvest/src/core/widgets/view_all.dart';
import 'package:landvest/src/features/home/model/model.dart';
import 'package:landvest/src/features/home/widget/ads_widget.dart';
import 'package:landvest/src/features/home/widget/quick_tab.dart';
import 'package:landvest/src/features/home/widget/transactions_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Home extends ConsumerStatefulWidget {
  const Home({
    required this.loginData,
    super.key,
  });
  final LoginData loginData;

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  bool isVisible = false;
  late RefreshController refreshController;
  List<TransactionModel>? value;
  late double currentBalance;

  late AssetImage assetsI;
  @override
  void initState() {
    super.initState();
    refreshController = RefreshController();
    currentBalance = widget.loginData.currentBalance;
    _getBalance();
    assetsI = const AssetImage(
      LandAssets.home,
    );

    setState(() {});
  }

  Future<void> _getBalance() async {
    String? currentBalances;
    currentBalances = await LocalStorage.instance.getCurrentBalance();
    currentBalance = double.parse(currentBalances.toString());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(assetsI, context);
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    final walletHistory = ref.watch(walletHistoryProvider);
    return Scaffold(
      appBar: AppBarHome(
        name: widget.loginData.firstName,
        backbutton: false,
        widget: Padding(
          padding: EdgeInsets.only(right: 20.w),
          child: Icon(
            Icons.notifications_outlined,
            size: 24.sp,
          ),
        ),
        translate: translate('home:home_title'),
        appBar: AppBar(),
      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        physics: const ClampingScrollPhysics(),
        onRefresh: () async {
          value!.clear();
          setState(() {});
          var _ = ref.refresh(walletHistoryProvider);
          final c = await GetRequest.getUserLoginCredentails();
          double newBalance = c!.data!['current_balance'];
          currentBalance = newBalance;
          refreshController.refreshCompleted();
        },
        onLoading: () async {
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
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        isVisible
                            ? '******'
                            : NumberFormat.currency(
                                symbol: '₦',
                                decimalDigits: 2,
                              ).format(currentBalance),
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fade(),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        height: 35.h,
                        child: IconButton(
                          splashColor: LandColors.transparent,
                          highlightColor: LandColors.transparent,
                          iconSize: 20.sp,
                          icon: Icon(
                            isVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: LandColors.backgroundColour,
                          ),
                          onPressed: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 35.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 8.h,
                        ),
                        margin: EdgeInsets.only(
                          left: 119.w,
                          right: 4.w,
                          bottom: 5.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          color: LandColors.transparent,
                        ),
                        child: Text(
                          '${widget.loginData.firstName} ${widget.loginData.lastName}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              25.verticalSpace,
              QuickLinksTab(widget: widget),
              43.verticalSpace,
              const Textss(),
              16.verticalSpace,
              Padding(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                ),
                child: SizedBox(
                  height: 224.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      List<String> images = [
                        LandAssets.product1,
                        LandAssets.product2,
                        LandAssets.product3,
                        LandAssets.product4,
                        LandAssets.product5,
                        LandAssets.product6,
                      ];

                      List<String> cost = [
                        'N1,000,000',
                        'N1,800,000',
                        'N1,000,000',
                        'N7,000,000',
                        'N2,500,000',
                        'N10,000,000',
                      ];

                      List<String> title = [
                        'Brook view cottage',
                        'Hilltop Residence',
                        'Land Banking Estate',
                        'Attitude Space Phase 2',
                        'Brook view cottage',
                        'Attitude Space Phase 1',
                      ];
                      List<String> location = [
                        'Ibusa, Delta',
                        'Leisure Park Asaba',
                        'Ibusa, Delta',
                        'Ibusa, Delta',
                        'Ibusa, Delta',
                        'Ibusa, Delta',
                      ];

                      return GeneralCard(
                        comingSoon: true,
                        cost: cost[index],
                        discount: '+24% in 8m',
                        height: 224.h,
                        image: images[index],
                        location: location[index],
                        title: title[index],
                        totalInvestors: '1092',
                        width: 214.w,
                      );
                    },
                  ),
                ),
              ),
              31.verticalSpace,
              ViewAll(
                textTile: 'History',
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
                              height: 200.h,
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
                                  String formattedDate =
                                      DateFormat('E MMM d, y')
                                          .format(originalDate);

                                  // Format the DateTime to the desired time format
                                  String formattedTime = DateFormat('hh:mm a')
                                      .format(originalDate);

                                  return InkWell(
                                    onTap: () {
                                      context.pushNamed(
                                        AppRoutes.historyMore.name,
                                        extra: value![index],
                                      );
                                    },
                                    child: Transcations(
                                      value: value,
                                      formattedDate: formattedDate,
                                      formattedTime: formattedTime,
                                      index: index,
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
            ],
          ),
        ),
      ),
    );
  }
}
