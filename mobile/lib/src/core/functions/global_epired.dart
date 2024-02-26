import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/core/widgets/dialog_boxes.dart';
import 'package:path_provider/path_provider.dart';

class GlobalFunctions {
  static Future<String> downloadPath() async {
    late String path;
    if (Platform.isAndroid) {
      path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOCUMENTS,
      );
    } else {
      path = (await getApplicationDocumentsDirectory()).path;
    }
    return path;
  }

  static Future<void> expiredeSession(BuildContext context) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    
    await showDialog(
      context: context,
      builder: (context) => DialogBoxes(
        notButton: true,
        icon: SvgPicture.asset(
          LandAssets.alert,
        ),
        text: translate('core:activity_timer'),
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
}
