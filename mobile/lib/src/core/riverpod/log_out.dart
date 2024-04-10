import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/widgets/dialog_boxes.dart';

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
    if (context.mounted) {
      context.goNamed(AppRoutes.logIn.name);
    }
  });
}
