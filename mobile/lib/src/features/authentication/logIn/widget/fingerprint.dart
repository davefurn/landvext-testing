import 'package:landvext/src/core/constants/imports.dart';

class FingerPrintWidget extends StatefulWidget {
  const FingerPrintWidget({
    required this.state,
    super.key,
    this.color,
  });
  final BiometricLoad state;
  final Color? color;
  @override
  State<FingerPrintWidget> createState() => _FingerPrintWidgetState();
}

class _FingerPrintWidgetState extends State<FingerPrintWidget> {
  @override
  Widget build(BuildContext context) => Container(
        height: 48.h,
        width: 48.w,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.14,
              color: Colors.black.withOpacity(0.20000000298023224),
            ),
            borderRadius: BorderRadius.circular(4.57),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: widget.state == BiometricLoad.loading
              ? SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    backgroundColor: widget.color ?? LandColors.ascentColor,
                    strokeWidth: 3.w,
                    color: LandColors.backgroundColour,
                  ),
                )
              : Center(
                  child: Icon(
                    Icons.fingerprint,
                    size: 32.sp,
                    color: LandColors.ascentColor,
                  ),
                ),
        ),
      );
}
