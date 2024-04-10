import 'package:landvext/src/core/constants/imports.dart';

class Categorys extends StatelessWidget {
  const Categorys({
    required this.text,
    super.key,
  });
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: LandColors.greyTextColor,
        ),
      );
}
