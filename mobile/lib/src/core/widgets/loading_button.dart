import 'package:landvext/src/core/constants/imports.dart';

class LoadingButton extends StatefulWidget {
  const LoadingButton({
    required this.state,
    required this.onTap,
    required this.text,
    super.key,
    this.width,
    this.color,
  });
  final LoadingState state;
  final Function() onTap;
  final String text;
  final double? width;
  final Color? color;

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  @override
  Widget build(BuildContext context) => MaterialButton(
        elevation: 0,
        onPressed: () {
          if (widget.state == LoadingState.normal) {
            widget.onTap();
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(4.r),
          ),
        ),
        color: widget.color ?? LandColors.mainColor,
        minWidth: widget.width ?? MediaQuery.of(context).size.width * 0.9,
        height: 48.h,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: widget.state == LoadingState.loading
              ? SizedBox(
                  width: 12.w,
                  height: 12.h,
                  child: CircularProgressIndicator(
                    backgroundColor: widget.color ?? LandColors.mainColor,
                    strokeWidth: 2.w,
                    color: LandColors.backgroundColour,
                  ),
                )
              : Text(
                  widget.text,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                ),
        ),
      );
}
