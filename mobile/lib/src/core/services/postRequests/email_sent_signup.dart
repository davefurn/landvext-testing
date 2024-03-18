import 'dart:developer';

import 'package:landvest/src/core/constants/imports.dart';

class PostRequest {
  static final NetworkService network = NetworkService();

  static Future<int?> emailSentSignUp(
    BuildContext context, {
    String? email,
  }) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    const path = AppEndpoints.emailSentSignUp;
    try {
      final response = await network.postRequestHandler(path, {
        'email': email,
      });

      if (response != null) {
        if (response.statusCode == 200) {
          if (context.mounted) {
            await ShowFlushBar.showSuccess(
              context: context,
              message: 'Email Verified',
            ).whenComplete(
              () {
                context.goNamed(AppRoutes.logIn.name);
              },
            );
          }
        } else if (response.statusCode == 400) {
          final data = response.data;

          if (data is Map<String, dynamic>) {
            final emailErrors = data['email'] as List<dynamic>?;
            final detailErrors = data['detail'] as List<dynamic>?;

            String message = '';

            if (emailErrors != null) {
              message += emailErrors.join('\n');
            }

            if (detailErrors != null) {
              if (message.isNotEmpty) {
                message += '\n';
              }
              message += detailErrors.join('\n');
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
        return response.statusCode;
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
    return null;
  }
}
