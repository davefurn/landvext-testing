import 'package:landvest/src/core/constants/imports.dart';

class LandTheme {
  LandTheme._();
  static ThemeData lightTheme = ThemeData(
    primaryColor: LandColors.mainColor,
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Inter',
    textTheme: TextsTheme.lightTheme,
    scaffoldBackgroundColor: LandColors.backgroundColour,
    splashColor: LandColors.transparent,
    highlightColor: LandColors.transparent,
  );
}
