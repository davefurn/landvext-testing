import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/core/services/get_requests.dart';

import 'package:landvest/src/core/widgets/dialog_boxes.dart';
import 'package:landvest/src/features/home/model/paginations_model.dart';

import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

final goalsProvider = FutureProvider.autoDispose(
  (ref) => GetRequest.getAllSavings(),
);

final getAllBanksProvider = FutureProvider.autoDispose(
  (ref) => GetRequest.getAllBanks(),
);

final referralProvider = FutureProvider.autoDispose(
  (ref) => GetRequest.getAllReferrals(),
);
final userDetailProvider = FutureProvider.autoDispose(
  (ref) => GetRequest.getUserLoginCredentails(),
);

final walletHistoryProvider = FutureProvider.autoDispose(
  (ref) => GetRequest.getAllUsersTransaction(),
);

final savingsHistoryProvider = FutureProvider.family(
  // ignore: avoid_types_on_closure_parameters
  (_, SavingsHistoryPaginationModel pagination) =>
      GetRequest.getAllSavingsTransaction(pagination),
);

final fingerPrintState =
    StateNotifierProvider<FingerprintState, bool>((ref) => FingerprintState());

class FingerprintState extends StateNotifier<bool> {
  FingerprintState() : super(false) {
    // Load state from SharedPreferences during initialization

    loadFromSharedPreferences();
  }

  void setEnabled({required bool value}) {
    state = value;
    saveToSharedPreferences(value: value);
  }

  Future<void> saveToSharedPreferences({required bool value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('fingerprint_enabled', value);
  }

  Future<void> loadFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('fingerprint_enabled') ?? false;
  }
}

// final goalsProvider = Provider<List<Goal>>(
//   (ref) => [],
// );

StateNotifierProvider<AppSessionService, int> appSessionServiceProvider =
    StateNotifierProvider((ref) => AppSessionService());

class AppSessionService extends StateNotifier<int> {
  AppSessionService() : super(0);

  void countTime() {
    state = 0;
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        state++;
        switch (state) {
          //! for 5 mins of inactivity, it would be case 300 seconds
          // 5 x 60
          case const (10 * 60):
            await performlogout(globalContext);
            timer.cancel();
            state = 0;
            break;
          default:
        }
      },
    );
  }

  //! set counter to zero
  void resetTimerState() {
    state = 0;
  }
}

final favoriteProvider = StateProvider<bool>((ref) => false);

Future<void> performlogout(BuildContext context) async {
  unawaited(
    showDialog(
      context: context,
      builder: (context) => DialogBoxes(
        notButton: true,
        icon: SvgPicture.asset(
          LandAssets.alert,
        ),
        text: 'Logged out due to inactivity',
      ),
    ),
  );

  Future.delayed(const Duration(seconds: 2), () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(LandConstants.loggedIn, false);
    if (context.mounted) {
      context.goNamed(AppRoutes.logIn.name);
    }
  });
}

final biometricProvider = Provider<BiometricState>((ref) => BiometricState());

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

    if (fingerprintEnabled == true) {
      if (!canAuthenticate && refreshToken == '' && context.mounted) {
        // Show appropriate dialog or handle the case
        await _showBiometricsNotActivatedDialog(
          context,
          'You need to login first',
        );
      } else if (canAuthenticate && refreshToken == null && context.mounted) {
        // Show appropriate dialog or handle the case
        await _showBiometricsNotActivatedDialog(
          context,
          'You need to login first',
        );
      } else if (!canAuthenticate && context.mounted) {
        // Show appropriate dialog or handle the case

        await _showBiometricsNotActivatedDialog(
          context,
          'Setup a fingerprint for your device',
        );
      } else if (canAuthenticate && refreshToken == '' && context.mounted) {
        // Show appropriate dialog or handle the case
        await _showBiometricsNotActivatedDialog(
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
          ],
        );

        if (didAuthenticate) {
          final NetworkService network = NetworkService();

          await network.postRequestHandler('v1/users/refresh-token/', {
            'refresh': refreshToken,
          }).then(
            (value) async {
              if (value != null) {
                if (value.statusCode == 200) {
                  await LocalStorage.instance
                      .setAccessToken(value.data['access']);

                  await LocalStorage.instance
                      .setRefreshToken(value.data['refresh']);

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
                  log(value.data);
                }
              }
            },
          );
        }
      }
    } else {
      if (context.mounted) {
        await _showBiometricsNotActivatedDialog(
          context,
          'Setup biometrics in the app',
        );
      }
    }
  }
}

Future<void> _showBiometricsNotActivatedDialog(
  BuildContext context,
  String text,
) async {
  await showDialog(
    context: context,
    builder: (context) => DialogBoxes(
      notButton: true,
      icon: SvgPicture.asset(
        LandAssets.alert,
      ),
      text: text,
    ),
  );
}
