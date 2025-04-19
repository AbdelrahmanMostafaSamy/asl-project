import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:winapp/Home.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:window_manager/window_manager.dart';

class splashscreen extends StatelessWidget {
  const splashscreen({super.key});
  @override
  Widget build(BuildContext context) {
    windowManager.setSize(const Size(600, 420));
    windowManager.setAlignment(Alignment.center);
    Window.setEffect(
      effect: WindowEffect.mica,
      dark: false,
    );
    return AnimatedSplashScreen(
      splash: Image.asset('Assets/Images/ASL-removebg-preview 1.png'),
      nextScreen: const choice(),
      animationDuration: const Duration(seconds: 3),
      duration: 1000,
      splashIconSize: 300,
      splashTransition: SplashTransition.rotationTransition
    );
  }
}