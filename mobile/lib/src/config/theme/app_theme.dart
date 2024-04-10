import 'package:landvext/src/core/constants/imports.dart';

class LandTheme {
  LandTheme._();
  static ThemeData lightTheme = ThemeData(
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: LandColors.backgroundColour,
    ),
    dialogBackgroundColor: LandColors.backgroundColour,
    dialogTheme: const DialogTheme(
      backgroundColor: LandColors.backgroundColour,
    ),
    primaryColor: LandColors.mainColor,
    brightness: Brightness.light,
    fontFamily: 'Inter',
    textTheme: TextsTheme.lightTheme,
    scaffoldBackgroundColor: LandColors.backgroundColour,
    splashColor: LandColors.transparent,
    highlightColor: LandColors.transparent,
  );
}
