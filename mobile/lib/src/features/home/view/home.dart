import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/riverpod/providers.dart';
import 'package:landvext/src/core/services/get_requests.dart';
import 'package:landvext/src/core/widgets/app_error.dart';
import 'package:landvext/src/core/widgets/appbar_home.dart';
import 'package:landvext/src/core/widgets/view_all.dart';
import 'package:landvext/src/features/home/model/model.dart';
import 'package:landvext/src/features/home/widget/dashboard.dart';
import 'package:landvext/src/features/home/widget/history_card.dart';
import 'package:landvext/src/features/home/widget/my_property_card.dart';
import 'package:landvext/src/features/home/widget/no_transaction_card.dart';
import 'package:landvext/src/features/home/widget/quick_tab.dart';
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
          double newBalance = c!.data['current_balance'];
          currentBalance = newBalance;
          refreshController.refreshCompleted();
        },
        onLoading: () async {
          try {
            final a = await GetRequest.getAllUsersTransaction();
            var b = (a!.data['transactions'] as List)
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
              DashBoardHome(
                assetsI: assetsI,
                isVisible: isVisible,
                currentBalance: currentBalance,
                widget: widget,
                onpressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
              ),
              25.verticalSpace,
              QuickLinksTab(widget: widget),
              43.verticalSpace,
              const Textss(),
              16.verticalSpace,
              const MyPropertyCard(),
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
                        ? HistoryCard(value: value)
                        : const NoTransactionCard();
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
