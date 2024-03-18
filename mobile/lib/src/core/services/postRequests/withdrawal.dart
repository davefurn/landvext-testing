import 'dart:developer';

import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/features/savings/views/withdrawal/model/receipt.dart';

class PostRequest {
  static final NetworkService network = NetworkService();
  static Future<void> withDrawal(
    BuildContext context, {
    String? accountNumber,
    String? amount,
    String? bank,
    BankTransaction? bankTransaction,
  }) async {
    String path = 'v1/wallets/providus-topup/';
    var token = await LocalStorage.instance.getAccessToken();
    String tokens = token.toString();

    try {
      final response = await network.postRequestHandler(
        path,
        {
          'account_number': accountNumber,
          'beneficiary_bank': bank,
          'amount': amount,
        },
        options: Options(headers: {'Authorization': 'JWT $tokens'}),
      );

      if (response != null) {
        if (response.statusCode == 200) {
          if (context.mounted) {
            await ShowFlushBar.showSuccess(
              context: context,
              message: 'Withdrawal Successful',
            ).then(
              (value) => context
                ..pop()
                ..pushNamed(
                  AppRoutes.withdrawalReceipt.name,
                  extra: bankTransaction,
                ),
            );
          }
        } else if (response.statusCode == 424) {
          final data = response.data;
          if (data is Map<String, dynamic>) {
            final title = data['detail'];
            String message = '';

            if (title != null) {
              message += title;
            }

            if (message.isNotEmpty && context.mounted) {
              await ShowFlushBar.showError(
                error: message,
                context: context,
              );
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
                error: 'Withdrawal not successful',
              );
            }
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
