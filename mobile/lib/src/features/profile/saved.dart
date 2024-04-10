import 'package:landvext/src/core/constants/imports.dart';

class Saved extends StatelessWidget {
  const Saved({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          widget: const SizedBox.shrink(),
          translate: 'Saved',
          appBar: AppBar(),
        ),
        body: Center(
          child: Image.asset(
            LandAssets.comingSoon,
            height: 145.h,
            width: 151.w,
            fit: BoxFit.contain,
          ),
        ),
      );
}
