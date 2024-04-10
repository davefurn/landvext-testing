import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landvext/src/core/services/get_requests.dart';
import 'package:landvext/src/features/home/model/paginations_model.dart';

final goalsProvider = FutureProvider.autoDispose(
  (ref) => GetRequest.getAllSavings(),
);

final getAllBanksProvider = FutureProvider.autoDispose(
  (ref) => GetRequest.getAllBanks(),
);

final referralProvider = FutureProvider.autoDispose(
  (ref) => GetRequest.getAllReferrals(),
);
final userDetailProvider = FutureProvider.autoDispose(
  (ref) => GetRequest.getUserLoginCredentails(),
);

final walletHistoryProvider = FutureProvider.autoDispose(
  (ref) => GetRequest.getAllUsersTransaction(),
);

final savingsHistoryProvider = FutureProvider.family(
  // ignore: avoid_types_on_closure_parameters
  (_, SavingsHistoryPaginationModel pagination) =>
      GetRequest.getAllSavingsTransaction(pagination),
);
