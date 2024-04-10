import 'package:landvext/src/core/constants/imports.dart';

class ExtendImage extends StatefulWidget {
  const ExtendImage({super.key});

  @override
  State<ExtendImage> createState() => _ExtendImageState();
}

class _ExtendImageState extends State<ExtendImage>
    with SingleTickerProviderStateMixin {
  late TransformationController controller;
  late AnimationController animationController;
  Animation<Matrix4>? animation;
  TapDownDetails? tapDownDetails;
  @override
  void initState() {
    super.initState();
    controller = TransformationController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        controller.value = animation!.value;
      });
  }

  @override
  void dispose() {
    animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          widget: const SizedBox.shrink(),
          translate: 'Survey Plan',
          appBar: AppBar(),
        ),
        body: GestureDetector(
          onTapDown: (details) => tapDownDetails = details,
          onTap: () {
            final position = tapDownDetails!.localPosition;
            const double scale = 2;
            final x = -position.dx * (scale - 1);
            final y = -position.dy * (scale - 1);
            final zoomed = Matrix4.identity()
              ..translate(x, y)
              ..scale(scale);

            final end =
                controller.value.isIdentity() ? zoomed : Matrix4.identity();

            animation = Matrix4Tween(
              begin: controller.value,
              end: end,
            ).animate(
              CurveTween(curve: Curves.easeOut).animate(
                animationController,
              ),
            );
            animationController.forward(from: 0);
          },
          child: Center(
            child: InteractiveViewer(
              transformationController: controller,
              clipBehavior: Clip.none,
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  LandAssets.survey,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      );
}
