import 'package:landvext/src/core/constants/imports.dart';

class PostRequestLogin {
  static final NetworkService network = NetworkService();

  static Future<void> login(
    BuildContext context, {
    String? email,
    String? password,
  }) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    const path = AppEndpoints.login;

    await network
        .postRequestHandler(path, {'email': email, 'password': password}).then(
      (value) async {
        if (value != null) {
          if (value.statusCode == 200) {
            final prefs = await SharedPreferences.getInstance();
            await LocalStorage.instance.setAccessToken(
              ((value.data as Map<String, dynamic>)['token']
                  as Map<String, dynamic>)['access'],
            );

            await LocalStorage.instance.setRefreshToken(
              ((value.data as Map<String, dynamic>)['token']
                  as Map<String, dynamic>)['refresh'],
            );

            LoginData data = LoginData.fromJson(value.data);
            await LocalStorage.instance.setEmail(
              email.toString(),
            );
            await LocalStorage.instance.saveUserData(data);

            await prefs.setBool(LandConstants.loggedIn, true);

            if (context.mounted) {
              context.goNamed(
                AppRoutes.home.name,
                extra: data,
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
