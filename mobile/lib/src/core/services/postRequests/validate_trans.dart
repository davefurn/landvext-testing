import 'dart:developer';

import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/features/savings/views/wallet/model/model_successful.dart';

class PostRequest {
  static final NetworkService network = NetworkService();

  static Future<void> validateTrans(
    BuildContext context, {
    String? externalTransactionId,
    bool? isWallet = false,
  }) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    String path;
    if (isWallet! == true) {
      path = 'v1/wallets/validate-providus-topup/';
    } else {
      path = 'v1/savings/validate-providus-topup/';
    }

    var token = await LocalStorage.instance.getAccessToken();
    String tokens = token.toString();

    try {
      final response = await network.postRequestHandler(
        path,
        {
          'external_transaction_id': externalTransactionId,
        },
        options: Options(headers: {'Authorization': 'JWT $tokens'}),
      );

      if (response != null && context.mounted) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          AccountProvidusValidate data =
              AccountProvidusValidate.fromJson(response.data);

          if (context.mounted) {
            await ShowFlushBar.showSuccess(
              duration: const Duration(seconds: 3),
              context: context,
              message:
                  'Status: ${data.status}, Account Number: ${data.accountNumber}, Amount: ${data.amount}',
            ).whenComplete(
              () async {
                if (data.status == 'PENDING') {
                } else {
                  context.pushReplacementNamed(
                    AppRoutes.savings.name,
                  );
                }
              },
            );
          }
        } else if (response.statusCode == 400) {
          final data = response.data;
          if (data is Map<String, dynamic>) {
            final title = data['external_transaction_id'];
            String message = '';

            if (title != null) {
              message += title;
            }

            if (message.isNotEmpty) {
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
                error: translate('authentication:snackbar_unknown_error'),
              );
            }
          }
        }
      }
    } on Exception catch (error) {
      log('Error: $error');
    }
  }
}
