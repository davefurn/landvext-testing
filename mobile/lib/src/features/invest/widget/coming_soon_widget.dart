import 'package:landvext/src/core/constants/imports.dart';

class ComingSoonWidget extends StatelessWidget {
  const ComingSoonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Positioned.fill(
        child: Container(
          color: Colors.white.withOpacity(0.7),
          child: Center(
            child: Image.asset(
              LandAssets.comingSoon,
              height: 145.h,
              width: 151.w,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
}
