import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/riverpod/biometrics/bio.dart';
import 'package:landvext/src/features/profile/widgets/switches.dart';
import 'package:local_auth/local_auth.dart';

class Biometrics extends ConsumerWidget {
  const Biometrics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fingerprintEnabled = ref.watch(fingerPrintState);
    return Scaffold(
      appBar: CustomAppbar(
        translate: 'Biometrics',
        appBar: AppBar(),
        widget: const SizedBox.shrink(),
      ),
      body: Column(
        children: [
          Switches(
            subText: 'for password',
            fingerprintEnabled: fingerprintEnabled,
            onchanged: (value) async {
              if (value) {
                // Check if fingerprint is available
                final localAuth = LocalAuthentication();
                bool canCheckBiometrics = await localAuth.canCheckBiometrics;

                if (canCheckBiometrics) {
                  // Authenticate user's fingerprint
                  bool isAuthenticated = await localAuth.authenticate(
                    localizedReason: 'Enable fingerprint for secure access',
                  );

                  if (isAuthenticated && context.mounted) {
                    ref.read(fingerPrintState.notifier).setEnabled(value: true);

                    await ShowFlushBar.showSuccess(
                      context: context,
                      message: 'FingerPrint Enabled',
                    );
                  } else {
                    // Fingerprint authentication failed
                    // You can handle this case accordingly
                    // For example, show an error message
                    // and set fingerprintEnabled.state back to false

                    if (context.mounted) {
                      ref
                          .read(fingerPrintState.notifier)
                          .setEnabled(value: false);
                      await ShowFlushBar.showError(
                        context: context,
                        error: 'FingerPrint Failed',
                      );
                    }
                  }
                } else {
                  // Fingerprint not available on the device
                  // You can handle this case accordingly
                  if (context.mounted) {
                    ref
                        .read(fingerPrintState.notifier)
                        .setEnabled(value: false);
                    await ShowFlushBar.showError(
                      context: context,
                      error: 'Biometrics not available on this device',
                    );
                  }
                }
              } else {
                // Disable fingerprint
                ref.read(fingerPrintState.notifier).setEnabled(value: false);
              }
            },
          ),
          10.verticalSpace,
          Switches(
            fingerprintEnabled: false,
            onchanged: (value) {},
            subText: 'For transaction',
          ),
        ],
      ),
    );
  }
}
