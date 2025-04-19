import 'package:flutter/material.dart';
import 'package:sign_language_app/screens/FirstScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPref;
bool result = false;

void main() async {
  var isArabic = true;
  bool choose = false;
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sign Language App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: Firstscreen());
  }
}
