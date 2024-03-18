import 'dart:developer';

import 'package:landvest/src/core/constants/imports.dart';

class PostRequest {
  static final NetworkService network = NetworkService();

  static Future<void> verifyEmail(
    BuildContext context, {
    String? passwordResetToken,
    String? email,
  }) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSignup = prefs.getBool(LandConstants.signedUpFlag) ?? false;
    if (kDebugMode) {
      print(isSignup);
    }

    final path = (isSignup == true)
        ? AppEndpoints.verifyEmail
        : AppEndpoints.verifyEmailForgotPassword;

    try {
      final response = isSignup == true
          ? await network.postRequestHandler(path, {
              'email': email,
              'otp': passwordResetToken,
            })
          : await network.postRequestHandler(path, {
              'email': email,
              'password_reset_token': passwordResetToken,
            });

      if (response != null) {
        if (response.statusCode == 200) {
          await LocalStorage.instance.setAccessToken(
            (response.data as Map<String, dynamic>)['access'],
          );

          await LocalStorage.instance.setRefreshToken(
            (response.data as Map<String, dynamic>)['refresh'],
          );

          // await LocalStorage.instance.saveUserData(response.data);

          if (context.mounted) {
            await ShowFlushBar.showSuccess(
              context: context,
            ).whenComplete(
              () {
                if (isSignup) {
                  context.go(AppRoutes.successfulSignUp.path);
                } else {
                  context.pushNamed(AppRoutes.forgotPassword.name);
                }
              },
            );
          }
        } else if (response.statusCode == 400) {
          final data = response.data;

          if (data is Map<String, dynamic>) {
            final emailErrors = data['email'] as List<dynamic>?;
            final passwordErrors =
                data['password_reset_token'] as List<dynamic>?;
            String message = '';

            if (emailErrors != null) {
              message += emailErrors.join('\n');
            }

            if (passwordErrors != null) {
              if (message.isNotEmpty) {
                message += '\n';
              }
              message += passwordErrors.join('\n');
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
        } else if (response.statusCode == 403) {
          final data = response.data;

          if (data is Map<String, dynamic>) {
            final otpError = data['otp'] as List<dynamic>?;

            String message = '';

            if (otpError != null) {
              message += otpError.join('\n');
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
        } else {
          late String message;
          try {
            message = '${(response.data as Map<String, dynamic>)["detail"]}';
          } on Exception catch (_) {
            message = translate('snackbar:code_unknown');
          }
          if (context.mounted) {
            await ShowFlushBar.showError(
              error: message,
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
