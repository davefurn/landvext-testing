import 'dart:math' as math;

import 'package:flutter/material.dart';

class SlideEffects extends StatelessWidget {
  const SlideEffects({
    required this.notifier,
    required this.child,
    required this.xOffset,
    required this.page,
    required this.yOffset,
    Key? key,
  }) : super(key: key);
  final ValueNotifier<double?>? notifier;
  final Widget child;
  final double xOffset;
  final double yOffset;
  final int? page;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: notifier!,
        builder: (context, anim) {
          var position = notifier!.value! - notifier!.value!.truncate();
          var offsetX = position * xOffset;

          if (notifier!.value! < page!) {
            offsetX -= xOffset;
          }

          var offsetY = position * yOffset;
          if (notifier!.value! < page!) {
            offsetY -= yOffset;
          } else {
            offsetY *= -1;
          }
          return Transform.translate(
            offset: Offset(offsetX * -1, offsetY * -1),
            child: child,
          );
        },
      );
}

class RotateEffects extends StatelessWidget {
  const RotateEffects({required this.notifier, required this.child, Key? key})
      : super(key: key);
  final ValueNotifier<double?>? notifier;
  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: notifier!,
        builder: (context, anim) => Transform.rotate(
          angle: notifier!.value! * math.pi,
          alignment: FractionalOffset.center,
          child: child,
        ),
      );
}

class ScaleEffects extends StatelessWidget {
  const ScaleEffects({
    required this.notifier,
    required this.child,
    required this.page,
    Key? key,
  }) : super(key: key);
  final ValueNotifier<double?>? notifier;
  final Widget child;
  final int? page;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: notifier!,
        builder: (context, anim) {
          var scale = 1 - (notifier!.value! - notifier!.value!.truncate());

          if (notifier!.value! < page!) {
            scale -= 1;
          }

          if (scale < 0) {
            scale *= -1;
          }

          return Transform.scale(
            scale: scale,
            alignment: FractionalOffset.center,
            child: child,
          );
        },
      );
}

class FadeEffects extends StatelessWidget {
  const FadeEffects({
    required this.notifier,
    required this.child,
    required this.page,
    Key? key,
  }) : super(key: key);
  final ValueNotifier<double?>? notifier;
  final Widget child;
  final int? page;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: notifier!,
        builder: (context, anim) {
          var opacity = 1 - (notifier!.value! - notifier!.value!.truncate());

          if (notifier!.value! < page!) {
            opacity = 1 - opacity;
          }

          return Opacity(opacity: opacity, child: child);
        },
      );
}
