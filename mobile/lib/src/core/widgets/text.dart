import 'package:landvext/src/core/constants/imports.dart';

class Texts extends StatelessWidget {
  const Texts({
    required this.text,
    super.key,
    this.padding,
    this.style,
    this.textAlign,
  });

  final String text;
  final double? padding;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          left: padding ?? 20.w,
          right: padding ?? 20.w,
        ),
        child: Text(
          text,
          style: style ??
              Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontSize: 14.sp,
                    color: LandColors.backgroundColour.withOpacity(0.5),
                  ),
          textAlign: textAlign ?? TextAlign.start,
        ),
      );
}
