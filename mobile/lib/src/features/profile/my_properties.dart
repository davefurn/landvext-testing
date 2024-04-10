import 'package:landvext/src/core/constants/imports.dart';

class MyProperties extends StatelessWidget {
  const MyProperties({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          widget: const SizedBox.shrink(),
          translate: 'My Properties',
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
