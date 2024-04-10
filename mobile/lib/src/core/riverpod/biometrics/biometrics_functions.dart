import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/riverpod/biometrics/bio.dart';
import 'package:landvext/src/core/riverpod/biometrics/bio_dialog.dart';
import 'package:landvext/src/core/services/get_requests.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

class BiometricState {
  BiometricState();

  bool canAuthenticate = false;
  bool didAuthenticate = false;

  Future<void> checkBiometricStatus(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await FingerprintState().loadFromSharedPreferences();
    final fingerprintEnabled = ref.watch(fingerPrintState);
    final LocalAuthentication auth = LocalAuthentication();
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final refreshToken = await LocalStorage.instance.getRefreshToken();
    canAuthenticate =
        canAuthenticateWithBiometrics && await auth.isDeviceSupported();

    if (!context.mounted) {
      return;
    }

    if (fingerprintEnabled == true) {
      if (!canAuthenticate || refreshToken == '') {
        await showBiometricsNotActivatedDialog(
          context,
          'You need to login first',
        );
      } else {
        didAuthenticate = await auth.authenticate(
          localizedReason: 'Use Biometric to unlock this app',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ),
          authMessages: [
            const AndroidAuthMessages(
              signInTitle: 'Authentication',
              biometricHint: '',
            ),
            const IOSAuthMessages(
              cancelButton: 'No Thanks',
            ),
          ],
        );

        if (didAuthenticate) {
          final NetworkService network = NetworkService();

          final value = await network.postRequestHandler(
            'v1/users/refresh-token/',
            {'refresh': refreshToken},
          );

          if (value != null && value.statusCode == 200) {
            await LocalStorage.instance.setAccessToken(value.data['access']);
            await LocalStorage.instance.setRefreshToken(value.data['refresh']);

            LoginData data = await LocalStorage.instance.getUserData();

            data.token.accessToken = value.data['access'];
            data.token.refreshToken = value.data['refresh'];

            final c = await GetRequest.getUserLoginCredentailsBiometrics(
              value.data['access'],
            );

            await LocalStorage.instance
                .setCurrentBalance(c!.data['current_balance'].toString());
            data
              ..currentBalance = c.data['current_balance']
              ..email = c.data['email']
              ..firstName = c.data['first_name']
              ..lastName = c.data['last_name']
              ..referralCode = c.data['referral_code']
              ..referralPoints = c.data['referral_points']
              ..phoneNumber = c.data['phone_number'];

            if (context.mounted) {
              context.goNamed(AppRoutes.home.name, extra: data);
            }
          } else {
            log(value!.data);
          }
        }
      }
    } else {
      await showBiometricsNotActivatedDialog(
        context,
        'Setup biometrics in the app',
      );
    }
  }
}
