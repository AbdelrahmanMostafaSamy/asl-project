import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:window_manager/window_manager.dart';
import 'package:winapp/Home.dart';
import 'Home2.dart';
import 'package:http/http.dart' as http;
import 'linksapp.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Global variables to store user information
String? globalName;
String? globalEmail;
String? globalPFP;
int? globalID;
// Function to toggle language preference and save it in shared preferences
Future<void> _toggleLanguagePreference() async {
  final prefs = await SharedPreferences.getInstance();
  isArabic = !(prefs.getBool('isArabic') ?? false);
  await prefs.setBool('isArabic', isArabic!);
}

// Login widget
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controllers for email and password input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Focus nodes for email and password input fields
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  
  // Form key to validate the form
  final _formKey = GlobalKey<FormState>();

  Future<void> _submitForm() async {
    // Get email and password from the input fields
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      // Send a POST request to the login endpoint
      final response = await http.post(
        Uri.parse(linkLogin),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      // Check if the response status is 200 (OK)
      if (response.statusCode == 200) {
        // Parse the response body
        final responseData = jsonDecode(response.body);
        final int id = responseData['id'];
        final pfpUrl = responseData['pfp_url'];
        final Name = responseData['username'];
        final email = responseData['email'];

        // Update global variables with user information
        setState(() {
          globalName = Name;
          globalEmail = email;
          globalID = id;
          globalPFP = pfpUrl;
          print(globalPFP);
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.green,
              content: Text("Successfully logged in")),
        );

        // Navigate to the home screen on success
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => home()),
        );
      } else {
        // Show an error message if the login failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.red,
              content: Text("Error: Wrong Password or Email :(")),
        );
      }
    } catch (e) {
      // Show an error message if an exception occurred
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Window configuration
    windowManager.setSize(const Size(860, 600));
    windowManager.setResizable(false);
    windowManager.setTitleBarStyle(TitleBarStyle.normal);
    windowManager.setTitle("Arabic Sign Language Project | Login");
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
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('Assets/Images/background.jpg'),
                fit: BoxFit.cover,
                opacity: 0.1,
              ),
            ),
          ),
          // Login Card
          SizedBox(
            height: 450,
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
                ],
              ),
            ),
          ),
          ListView(
            padding: const EdgeInsets.symmetric(vertical: 80),
            children: [
              Column(
                children: [
                  // Logo
                  const Image(
                    image: AssetImage('Assets/Images/ASL-removebg-preview.png'),
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(height: 20),
                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email Field
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            height: 48,
                            width: 300,
                            child: TextFormField(
                              controller: _emailController,
                              focusNode: _emailFocusNode,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                hintText:
                                    isArabic! ? "البريد الإلكتروني" : "Email",
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.all(8),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return isArabic!
                                      ? "يرجى إدخال بريد إلكتروني"
                                      : 'Please enter an email';
                                }
                                if (!value.contains("@")) {
                                  return isArabic!
                                      ? 'يرجى إدخال بريد إلكتروني صالح'
                                      : 'Please enter a valid email';
                                }
                                return null;
                              },
                              style: const TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Password Field
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            height: 48,
                            width: 300,
                            child: TextFormField(
                              controller: _passwordController,
                              focusNode: _passwordFocusNode,
                              textInputAction: TextInputAction.done,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText:
                                    isArabic! ? "كلمة المرور" : "Password",
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.all(8),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return isArabic!
                                      ? 'يرجى إدخال كلمة مرور'
                                      : 'Please enter a password';
                                }
                                return null;
                              },
                              style: const TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                              onFieldSubmitted: (_) {
                                if (_formKey.currentState!.validate()) {
                                  _submitForm();
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Login Button
                        SizedBox(
                          height: 45,
                          width: 170,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _submitForm();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffBA33AB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            child: Text(
                              isArabic! ? 'تسجيل الدخول' : 'Login',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 15.0,
            left: 16.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black87,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_left_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const choice(),
                  ));
                },
              ),
            ),
          ),
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
      ),
    );
  }
}
