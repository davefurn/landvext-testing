import 'package:landvext/src/core/constants/imports.dart';

class TextsTheme {
  static TextTheme lightTheme = TextTheme(
    //titles
    headlineLarge: TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600,
      fontSize: 32.sp,
      color: LandColors.textColorVeryBlack,
      letterSpacing: -0.2,
    ),

    //subtitles
    headlineMedium: TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
      fontSize: 16.sp,
      color: LandColors.textColorVeryBlack,
      letterSpacing: -0.2,
    ),

    //description
    headlineSmall: TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600,
      fontSize: 14.sp,
      color: LandColors.textColorVeryBlack,
      letterSpacing: -0.2,
    ),
    //hintext
    bodySmall: TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
      fontSize: 14.sp,
      color: LandColors.textColorHint,
      letterSpacing: -0.2,
    ),
    //buttonText
    bodyMedium: TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w700,
      fontSize: 14.sp,
      color: LandColors.backgroundColour,
      letterSpacing: -0.2,
    ),
    //title
    bodyLarge: TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w700,
      fontSize: 24.sp,
      color: LandColors.textColorVeryBlack,
      letterSpacing: -0.2,
    ),
    titleSmall: TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
      fontSize: 12.sp,
      color: LandColors.textColorVeryBlack,
      letterSpacing: -0.2,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600,
      fontSize: 36.sp,
      color: LandColors.backgroundColour,
      letterSpacing: -0.2,
    ),
  );
}
