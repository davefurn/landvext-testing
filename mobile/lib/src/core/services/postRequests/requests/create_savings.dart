import 'dart:developer';

import 'package:landvext/src/core/constants/imports.dart';

class PostRequestCreateSavings {
  static final NetworkService network = NetworkService();

  static Future<void> createSavings(
    BuildContext context, {
    String? savingsType,
    String? shortDescription,
    String? despositFrequency,
    int? target,
  }) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    const path = AppEndpoints.createSavings;
    var token = await LocalStorage.instance.getAccessToken();
    String tokens = token.toString();

    try {
      final response = await network.postRequestHandler(
        path,
        {
          'savings_type': savingsType,
          'short_description': shortDescription,
          'deposit_frequency': despositFrequency,
          'target': target,
        },
        options: Options(headers: {'Authorization': 'JWT $tokens'}),
      );

      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (context.mounted) {
            final Map<String, dynamic> responseData = response.data;
            final id = responseData['id'];
            context.goNamed(
              AppRoutes.deposit.name,
              pathParameters: {'id': id.toString()},
            );
          }
        } else if (response.statusCode == 400 || response.statusCode == 401) {
          final data = response.data;

          if (data is Map<String, dynamic>) {
            final passwordErrors = data['detail'] as List<dynamic>?;
            final title = data['title'];
            String message = '';

            if (passwordErrors != null) {
              message += passwordErrors.join('\n');
            }
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
