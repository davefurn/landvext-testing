import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:landvext/src/core/constants/imports.dart';

class ShowFlushBar {
  static Future<void> showError({
    required BuildContext context,
    int duration = 1,
    String? error,
  }) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    final flushBar = Flushbar(
      shouldIconPulse: false,
      icon: SvgPicture.asset(
        LandAssets.warning,
        width: 28.w,
        height: 28.h,
      ),
      backgroundColor: const Color(0xffFFF8EB),
      borderColor: const Color(0xffFCBB4D),
      borderRadius: BorderRadius.circular(4.r),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      messageText: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Error',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: LandColors.textColorVeryBlack,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              letterSpacing: -0.02,
            ),
          ),
          Text(
            error ?? translate('snackbar:code_null_internet'),
            textAlign: TextAlign.start,
            style: TextStyle(
              color: LandColors.textColorGrey,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              letterSpacing: -0.02,
            ),
          ),
        ],
      ),
      positionOffset: kBottomNavigationBarHeight.h + 20.h,
      duration: Duration(seconds: duration),
    );
    await flushBar.show(context);
  }

  static Future<void> showSuccess({
    required BuildContext context,
    String? message,
    Duration? duration,
    Function()? perform,
  }) async {
    final flushBar = Flushbar(
      backgroundColor: const Color(0xffEDFFF5),
      borderColor: LandColors.green,
      borderRadius: BorderRadius.circular(4.r),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      messageText: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Successful',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: LandColors.textColorVeryBlack,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              letterSpacing: -0.02,
            ),
          ),
          Text(
            message ?? '',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: LandColors.textColorGrey,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              letterSpacing: -0.02,
            ),
          ),
        ],
      ),
      positionOffset: kBottomNavigationBarHeight.h + 20.h,
      duration: duration ?? const Duration(seconds: 1),
    );
    await flushBar.show(context);
    if (perform != null) {
      perform();
    }
  }
}
