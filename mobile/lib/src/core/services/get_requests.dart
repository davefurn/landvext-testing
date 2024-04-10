import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/features/home/model/paginations_model.dart';

class GetRequest {
  static final NetworkService network = NetworkService();

  static Future<Response<dynamic>?> getSpecificSavings(String id) async {
    var path = 'v1/savings/$id/';
    var token = (await LocalStorage.instance.getAccessToken())!;

    return network.getRequestHandler(
      path,
      options: Options(headers: {'Authorization': 'JWT $token'}),
    );
  }

  static Future<Response<dynamic>?> getAllSavings() async {
    var path = 'v1/savings';
    var token = (await LocalStorage.instance.getAccessToken())!;

    return network.getRequestHandler(
      path,
      options: Options(headers: {'Authorization': 'JWT $token'}),
    );
  }

  static Future<Response<dynamic>?> getUserLoginCredentailsBiometrics(
    String token,
  ) async {
    var path = 'v1/users/me';

    return network.getRequestHandler(
      path,
      options: Options(headers: {'Authorization': 'JWT $token'}),
    );
  }

  static Future<Response<dynamic>?> getUserLoginCredentails() async {
    var path = 'v1/users/me';
    var token = (await LocalStorage.instance.getAccessToken())!;

    return network.getRequestHandler(
      path,
      options: Options(headers: {'Authorization': 'JWT $token'}),
    );
  }

  static Future<Response<dynamic>?> getAllBanks() async {
    var path = 'postingrest/GetNIPBanks';

    return network.getRequestDifferntUrlHandler(
      path,
      options: Options(headers: {}),
    );
  }

  static Future<Response<dynamic>?> getAllReferrals() async {
    var path = 'v1/users/referrals/';
    var token = (await LocalStorage.instance.getAccessToken())!;

    return network.getRequestHandler(
      path,
      options: Options(headers: {'Authorization': 'JWT $token'}),
    );
  }

  static Future<Response<dynamic>?> getAllUsersTransaction() async {
    var path = 'v1/users/wallet-withtransactions/';
    var token = (await LocalStorage.instance.getAccessToken())!;

    return network.getRequestHandler(
      path,
      options: Options(headers: {'Authorization': 'JWT $token'}),
    );
  }

  static Future<Response<dynamic>?> getAllSavingsTransaction(
    SavingsHistoryPaginationModel pagination,
  ) async {
    var path = 'v1/savings/all-transactions/?page=${pagination.currentPage}';
    var token = (await LocalStorage.instance.getAccessToken())!;

    return network.getRequestHandler(
      path,
      options: Options(headers: {'Authorization': 'JWT $token'}),
    );
  }
}
