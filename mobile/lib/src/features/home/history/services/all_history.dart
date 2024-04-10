import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/riverpod/providers.dart';
import 'package:landvext/src/core/widgets/app_error.dart';
import 'package:landvext/src/features/home/model/model.dart';
import 'package:landvext/src/features/home/widget/all_history_card.dart';
import 'package:landvext/src/features/home/widget/no_trans_big.dart';

class AllHistory extends StatelessWidget {
  const AllHistory({
    required this.ref,
    super.key,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) => Consumer(
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
                    ? AllHistoryCard(value: value)
                    : const NoTransBig();
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
      );
}
