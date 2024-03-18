import 'dart:developer';

import 'package:landvest/src/core/constants/imports.dart';

class PostRequest {
  static final NetworkService network = NetworkService();

  static Future<int?> emailSent(
    BuildContext context, {
    bool? reSend = false,
    String? email,
  }) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    final path = (reSend ?? false)
        ? AppEndpoints.emailSentSignUp
        : AppEndpoints.emailSent;
    try {
      final response = await network.postRequestHandler(path, {
        'email': email,
      });

      if (response != null) {
        if (response.statusCode == 200) {
          if (context.mounted) {
            await ShowFlushBar.showSuccess(
              context: context,
              message: translate(
                'authentication:sent_email_endpoint',
              ),
            ).whenComplete(
              () async {
                await LocalStorage.instance.setEmail(
                  email.toString(),
                );
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool(LandConstants.signedUpFlag, false);
                await LocalStorage.instance.setResetToken(
                  (response.data
                      as Map<String, dynamic>)['password_reset_token'],
                );
                if (reSend!) {
                  return;
                } else {
                  if (context.mounted) {
                    await context.pushNamed(
                      AppRoutes.emailValidation.name,
                    );
                  }
                }
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
