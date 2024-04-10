import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/riverpod/biometrics/biometrics_functions.dart';
import 'package:landvext/src/core/widgets/dialog_boxes.dart';

Future<void> showBiometricsNotActivatedDialog(
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

final biometricProvider = Provider<BiometricState>((ref) => BiometricState());
