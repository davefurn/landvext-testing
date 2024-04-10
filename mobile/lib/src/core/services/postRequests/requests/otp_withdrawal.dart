import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/features/savings/views/withdrawal/model/receipt.dart';

class PostRequestRequestOtpWallet {
  static final NetworkService network = NetworkService();
  static Future<void> requestOtpWallet(
    BuildContext context, {
    String? otp,
    String? externalTrans,
    BankTransaction? bankTransaction,
    bool? walletRoute,
  }) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    String path =
        walletRoute! ? AppEndpoints.otpWallet : AppEndpoints.otpSavings;
    var token = await LocalStorage.instance.getAccessToken();
    String tokens = token.toString();

    await network
        .postRequestHandler(
      path,
      {
        'external_transaction_id': externalTrans,
        'withdrawal_otp': otp,
      },
      options: Options(headers: {'Authorization': 'JWT $tokens'}),
    )
        .then(
      (value) async {
        if (value != null) {
          if (value.statusCode! >= 200 && value.statusCode! < 300) {
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
          } else if (value.statusCode == 502) {
            String message = translate('snackbar:code_502');
            await ShowFlushBar.showError(
              error: message,
              context: context,
            );
          } else if (value.statusCode! >= 400 && value.statusCode! < 500) {
            late String message;
            try {
              message = '${(value.data as Map<String, dynamic>)["detail"]}';
            } on Exception catch (_) {
              message = translate('snackbar:code_unknown');
            }

            await ShowFlushBar.showError(
              error: message,
              context: context,
            ).whenComplete(
              () => context.pop(),
            );
          } else if (value.statusCode == 500) {
            String message = 'Unexpected error';
            await ShowFlushBar.showError(
              error: message,
              context: context,
            );
          } else if (value.statusCode == 401) {
            late String message;
            try {
              message = '${(value.data as Map<String, dynamic>)["detail"]}';
            } on Exception catch (_) {
              message = translate('snackbar:code_unknown');
            }

            await ShowFlushBar.showError(
              error: message,
              context: context,
            );
          } else {
            String message = 'Unexpected error';
            await ShowFlushBar.showError(
              error: message,
              context: context,
            );
          }
        } else {
          await ShowFlushBar.showError(
            context: context,
          );
        }
      },
    );
  }
}
