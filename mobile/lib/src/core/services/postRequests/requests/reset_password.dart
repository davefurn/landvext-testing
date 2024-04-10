import 'dart:developer';

import 'package:landvext/src/core/constants/imports.dart';

class PostRequestResetPassword {
  static final NetworkService network = NetworkService();

  static Future<void> resetPassword(
    BuildContext context, {
    String? password,
    String? confirmPassword,
  }) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    const path = AppEndpoints.resetPassword;
    var token = await LocalStorage.instance.getAccessToken();
    String tokens = token.toString();

    try {
      final response = await network.postRequestHandler(
        path,
        {
          'password': password,
          'confirm_password': confirmPassword,
        },
        options: Options(headers: {'Authorization': 'JWT $tokens'}),
      );

      if (response != null) {
        if (response.statusCode == 200) {
          if (context.mounted) {
            await ShowFlushBar.showSuccess(
              context: context,
              message: (response.data as Map<String, dynamic>)['detail'],
            ).whenComplete(
              () {
                context.go(AppRoutes.logIn.path);
              },
            );
          }
        } else if (response.statusCode == 400) {
          final data = response.data;

          if (data is Map<String, dynamic>) {
            final passwordErrors = data['password'] as List<dynamic>?;
            final confirmPasswordErrors =
                data['confirm_password'] as List<dynamic>?;
            String message = '';

            if (passwordErrors != null) {
              message += passwordErrors.join('\n');
            }

            if (confirmPasswordErrors != null) {
              if (message.isNotEmpty) {
                message += '\n';
              }
              message += confirmPasswordErrors.join('\n');
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
