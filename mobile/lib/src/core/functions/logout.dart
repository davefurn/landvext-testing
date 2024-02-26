import 'package:landvest/src/core/constants/imports.dart';

Future<void> clearTokens() async {
  await LocalStorage.instance.setAccessToken('');
  await LocalStorage.instance.setRefreshToken('');
}
