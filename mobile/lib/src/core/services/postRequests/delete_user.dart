import 'package:landvest/src/core/constants/imports.dart';

class PostRequest {
  static final NetworkService network = NetworkService();
  static Future<void> deleteUser(
    BuildContext context, {
    String? otp,
  }) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    const path = AppEndpoints.deleteAccount;
    var token = await LocalStorage.instance.getAccessToken();
    String tokens = token.toString();

    await network
        .postRequestHandler(
      path,
      {
        'otp': otp,
      },
      options: Options(headers: {'Authorization': 'JWT $tokens'}),
    )
        .then(
      (value) async {
        if (value != null) {
          if (value.statusCode! >= 200 && value.statusCode! < 300) {
            if (context.mounted) {
              context.goNamed(
                AppRoutes.logIn.name,
              );
            }
          } else if (value.statusCode == 502) {
            String message = translate('snackbar:code_502');
            await ShowFlushBar.showError(
              error: message,
              context: context,
            );
          } else if (value.statusCode == 403) {
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
              () => context.goNamed(AppRoutes.emailValidation.name),
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
