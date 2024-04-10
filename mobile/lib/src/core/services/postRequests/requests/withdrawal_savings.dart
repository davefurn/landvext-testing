import 'dart:developer';
import 'package:landvext/src/core/constants/imports.dart';

class PostRequestWithDrawalSavings {
  static final NetworkService network = NetworkService();
  static Future<void> withDrawalSavings(
    BuildContext context, {
    String? accountNumber,
    String? bank,
    String? id,
  }) async {
    String path = 'v1/savings/$id/withdrawal-to-providus-nip/';
    var token = await LocalStorage.instance.getAccessToken();
    String tokens = token.toString();

    try {
      final response = await network.postRequestHandler(
        path,
        {
          'account_number': accountNumber,
          'beneficiary_bank': bank,
        },
        options: Options(headers: {'Authorization': 'JWT $tokens'}),
      );

      if (response != null) {
        if (response.statusCode == 200) {
          print(response.data['external_transaction_id'].toString());
          if (context.mounted) {
            await ShowFlushBar.showSuccess(
              context: context,
              message: 'Withdrawal Initiated',
            ).whenComplete(() {
              context.pushNamed(
                AppRoutes.otpWithDrawal.name,
                pathParameters: {
                  'route': 'false',
                  'externalTrans':
                      response.data['external_transaction_id'].toString(),
                },
              );
            });
          }
        } else if (response.statusCode! >= 400 && response.statusCode! < 500) {
          final data = response.data['detail'];

          if (context.mounted) {
            await ShowFlushBar.showError(
              context: context,
              error: data,
            );
          }
        }
      } else {
        if (context.mounted) {
          await ShowFlushBar.showError(
            context: context,
            error: 'Withdrawal not successful',
          );
        }
      }
    } on Exception catch (error) {
      log('Error: $error');
    }
  }
}
