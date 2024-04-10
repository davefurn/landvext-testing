import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/riverpod/providers.dart';
import 'package:landvext/src/core/services/get_requests.dart';
import 'package:landvext/src/core/widgets/app_error.dart';
import 'package:landvext/src/core/widgets/view_all.dart';
import 'package:landvext/src/features/home/model/model.dart';
import 'package:landvext/src/features/savings/widgets/dashboard_wallet.dart';
import 'package:landvext/src/features/savings/widgets/wallet_button.dart';
import 'package:landvext/src/features/savings/widgets/wallet_history_card.dart';
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
            DashboardWallet(
              assetsI: assetsI,
              initialAmount: initialAmount,
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
                      ? WalletTransactionCard(
                          value: value,
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
            const WalletButton(),
            50.verticalSpace,
          ],
        ),
      ),
    );
  }
}
