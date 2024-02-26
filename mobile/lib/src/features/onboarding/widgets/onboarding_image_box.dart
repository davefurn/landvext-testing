import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardImagebox extends StatelessWidget {
  const OnboardImagebox({
    required this.assets, required this.index, super.key,
  });

  final List<String> assets;
  final int index;

  @override
  Widget build(BuildContext context) => Container(
      height: 418.h,
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(48.r),
          bottomRight: Radius.circular(48.r),
        ),
      ),
      child: Image.asset(
        assets[index],
        width: double.maxFinite,
        fit: BoxFit.cover,
      ),
    );
}
