import 'dart:developer';

import 'package:landvext/src/core/constants/imports.dart';

class PostRequestCreateUser {
  static final NetworkService network = NetworkService();

  static Future<void> createUser(
    BuildContext context, {
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? phone,
    String? referralCode = '',
  }) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    const path = AppEndpoints.signUp;
    try {
      await network.postRequestHandler(path, {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phone,
        'referral_code': referralCode,
      }).then(
        (value) async {
          if (value != null) {
            if (value.statusCode == 200 || value.statusCode == 201) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool(LandConstants.signedUpFlag, true);

              await LocalStorage.instance.setEmail(
                email.toString(),
              );
              if (context.mounted) {
                context.goNamed(
                  AppRoutes.emailValidation.name,
                );
              }
            } else if (value.statusCode == 400) {
              final data = value.data;

              if (data is Map<String, dynamic>) {
                final emailErrors = data['email'] as List<dynamic>?;
                final phoneErrors = data['phone_number'] as List<dynamic>?;

                String message = '';

                if (emailErrors != null) {
                  message += emailErrors.join('\n');
                  // Check for a specific message indicating email already verified
                  if (emailErrors
                      .contains('a user with this email already exists !')) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool(LandConstants.signedUpFlag, true);
                    await LocalStorage.instance.setEmail(
                      email.toString(),
                    );
                  }
                } else if (phoneErrors != null) {
                  if (message.isNotEmpty) {
                    message += '\n';
                  }
                  message += phoneErrors.join('\n');
                } else {
                  message += 'incorrect refferal code';
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
                await ShowFlushBar.showError(
                  context: context,
                  error: 'Incorrect referral code',
                );
              }
            } else {
              await ShowFlushBar.showError(
                context: context,
                error: translate('authentication:snackbar_unknown_error'),
              );
            }
          } else {
            if (context.mounted) {
              await ShowFlushBar.showError(
                context: context,
              );
            }
          }
        },
      );
    } on Exception catch (error) {
      log('Error: $error');
    }
  }
}
