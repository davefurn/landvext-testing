import 'dart:developer';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/services/postRequests/widgets/dialog_providus.dart';
import 'package:landvext/src/features/savings/views/wallet/model/model.dart';

class PostRequestCreateProvidus {
  static final NetworkService network = NetworkService();

  static Future<int?> createProvidus(
    BuildContext context, {
    int? id,
  }) async {
    String path = 'v1/savings/$id/providus-topup/';
    var token = await LocalStorage.instance.getAccessToken();
    String tokens = token.toString();

    try {
      final response = await network.postRequestHandler(
        path,
        {},
        options: Options(headers: {'Authorization': 'JWT $tokens'}),
      );

      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          AccountProvidus data = AccountProvidus.fromJson(response.data);
          await LocalStorage.instance.saveProvidusAccount(data);
          if (context.mounted) {
            await showModalBottomSheet(
              context: globalContext,
              isScrollControlled: true,
              builder: (context) => BottomSheetProvidus(data: data),
            );
          }
        } else if (response.statusCode == 403) {
          final data = response.data.toString();

          if (data.contains("this savings doesn't belong to you!")) {
            // Directly show the error message
            if (context.mounted) {
              await ShowFlushBar.showError(
                error: "this savings doesn't belong to you!",
                context: context,
              ).whenComplete(() {
                if (context.mounted) {
                  context.pop();
                }
              });
            }
          } else {
            // Handle other 403 errors
            if (context.mounted) {
              await ShowFlushBar.showError(
                context: context,
              ).whenComplete(() async {
                if (context.mounted) {
                  context.pushReplacementNamed(
                    AppRoutes.providus.name,
                    pathParameters: {'id': id.toString()},
                  );
                }
              });
            }
          }
        }
        // Return the status code
        return response.statusCode;
      } else {
        if (context.mounted) {
          await ShowFlushBar.showError(
            context: context,
          );
        }
        // Return a default status code for cases where response is null
        return 500; // Use an appropriate default status code
      }
    } on Exception catch (error) {
      log('Error: $error');
      // Return a default status code for exception cases
      return 500; // Use an appropriate default status code
    }
  }
}
