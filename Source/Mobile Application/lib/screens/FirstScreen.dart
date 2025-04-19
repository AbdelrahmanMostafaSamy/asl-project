import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:sign_language_app/screens/SignorLogScreen.dart';

class Firstscreen extends StatelessWidget {
  const Firstscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashIconSize: 180,
      splash: Image.asset(
        "images/ASLP Logo2.png",
      ),
      nextScreen: SignOrLogScreen(name: "Hamza"),
      animationDuration: Duration(milliseconds: 500),
      splashTransition: SplashTransition.rotationTransition,
    );
  }
}
