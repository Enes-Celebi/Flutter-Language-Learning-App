import 'package:flutter/material.dart';

class AnimationHelper {
  static AnimationController createAnimationController(
      {required TickerProvider vsync,
      required Duration duration}) {
    return AnimationController(
      duration: duration,
      vsync: vsync,
    );
  }

  static Animation<Offset> createSlideAnimation(
      AnimationController controller) {
    return Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.4, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
  }

  static List<Animation<double>> createFlagSizeAnimations(
      List<AnimationController> controllers) {
    return List.generate(
      controllers.length,
      (index) => Tween<double>(begin: 0.01, end: 1.0).animate(CurvedAnimation(
        parent: controllers[index],
        curve: Curves.easeOut,
      )),
    );
  }

  static Future<void> startFlagAnimations(
      List<AnimationController> controllers) async {
    for (var i = 0; i < controllers.length; i++) {
      controllers[i].forward();
      if (i < controllers.length - 1) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
  }

  static Future<void> reverseFlagAnimations(
      List<AnimationController> controllers) async {
    for (var controller in controllers) {
      controller.duration = const Duration(milliseconds: 300);
      controller.reverse();
    }
  }
}
