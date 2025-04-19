import 'package:flutter/material.dart';
import 'package:winapp/SplashScreen.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  windowManager.setSize(const Size(600, 420));
  windowManager.setResizable(false);
  windowManager.setMaximizable(false);
  windowManager.show();
  windowManager.setTitleBarStyle(TitleBarStyle.hidden);
  windowManager.setTitle("Arabic Sign Language Project");
  await Window.initialize();
  await Window.setEffect(
    effect: WindowEffect.acrylic,
    dark: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: splashscreen(),
    );
  }

}