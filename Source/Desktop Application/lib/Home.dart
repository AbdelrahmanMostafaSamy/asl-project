import 'package:flutter/material.dart';
import 'package:winapp/login.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:window_manager/window_manager.dart';
import 'package:winapp/Signup.dart';
import 'Home2.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _toggleLanguagePreference() async {
  //Get Language Preference using Shared Preferences package
  final prefs = await SharedPreferences.getInstance();
  isArabic = !(prefs.getBool('isArabic') ?? false);
  //set boolean variable "isArabic" to either true or false
  await prefs.setBool('isArabic', isArabic!);
}
class choice extends StatefulWidget {
  const choice({super.key});

  @override
  State<choice> createState() => _choiceState();
}

class _choiceState extends State<choice> {
  @override
  Widget build(BuildContext context) {
    windowManager.setSize(const Size(860, 600)); // set size to 860 x 600
    windowManager.setResizable(false); //set windows to unresizable
    windowManager.setTitleBarStyle(TitleBarStyle.normal); //set title bar to normal
    windowManager.setTitle("Arabic Sign Language Project"); //set name for window
    windowManager.setAlignment(Alignment.center); // align window to center
    //apply effect
    Window.setEffect(
      effect: WindowEffect.mica,
      dark: false,
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('Assets/Images/background.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.1,
                ),
              ),
            ),
            SizedBox(
              height: 500,
              width: 420,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: const Color(0xffD9D9D9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ]
                ),
              ),
            ),
            ListView(children: [
              const SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  const Image(
                      image: AssetImage(
                        'Assets/Images/ASL-removebg-preview.png',
                      ),
                      height: 260,
                      width: 260),
                  const SizedBox(height: 20),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 40),
                    child: Container(
                      height: 45,
                      width: 170,
                      decoration: const BoxDecoration(
                        color: Color(0xffBA33AB),
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Login(),
                          ));
                        },
                        child: Text(
                          isArabic! ? 'تسجيل الدخول' :
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      height: 45,
                      width: 170,
                      decoration: const BoxDecoration(
                        color: Color(0xffBA33AB),
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Signup(),
                          ));
                        },
                        child: Text(
                          isArabic! ? 'الأشتراك' :
                          'Sign up',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ]),
            Positioned(
            top: 16,
            right: 16,
            child: ElevatedButton(
                onPressed: () async {
                  await _toggleLanguagePreference();
                  setState(() {});
                  if (isArabic!) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم التبديل بنجاح!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Switched Successfully!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: const Icon(
                  Icons.language,
                  color: Colors.white,
                  size: 30,
                )),
          ),
          ],
        ));
  }
}
