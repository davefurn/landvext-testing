import 'dart:developer';

import 'package:landvest/src/core/constants/imports.dart';

class PostRequest {
  static final NetworkService network = NetworkService();

  static Future<void> depositFromWallet(
    BuildContext context, {
    int? amount,
    String? id,
  }) async {
    String path = 'v1/savings/$id/topup-from-wallet/';
    var token = await LocalStorage.instance.getAccessToken();
    String tokens = token.toString();

    try {
      final response = await network.postRequestHandler(
        path,
        {
          'amount': amount,
        },
        options: Options(headers: {'Authorization': 'JWT $tokens'}),
      );

      if (response != null) {
        if (response.statusCode == 200) {
          if (context.mounted) {
            await ShowFlushBar.showSuccess(
              context: context,
              message: 'Deposit Successful',
            ).then(
              (value) => context
                ..pop()
                ..pop(),
            );
          }
        } else if (response.statusCode == 403) {
          final message = response.data;

          if (context.mounted) {
            await ShowFlushBar.showError(
              error: message,
              context: context,
            );
          }
        } else {
          if (context.mounted) {
            await ShowFlushBar.showError(
              context: context,
            );
          }
        }
      } else {
        if (context.mounted) {
          await ShowFlushBar.showError(
            context: context,
          );
        }
      }
    } on Exception catch (error) {
      log('Error: $error');
    }
  }
}
