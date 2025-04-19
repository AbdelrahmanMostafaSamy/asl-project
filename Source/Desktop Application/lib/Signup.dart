import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:winapp/Home.dart';
import 'package:winapp/linksapp.dart';
import 'package:winapp/login.dart';
import 'package:window_manager/window_manager.dart';
import 'package:http/http.dart' as http;
import 'Home2.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _toggleLanguagePreference() async {
  final prefs = await SharedPreferences.getInstance();
  isArabic = !(prefs.getBool('isArabic') ?? false);
  await prefs.setBool('isArabic', isArabic!);
}

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // Controllers for form fields
  final TextEditingController nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  final TextEditingController passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();

  final TextEditingController confirmPasswordController = TextEditingController();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  // Function to pick an image
  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Function to encode image to Base64
  String? _encodeImageToBase64(File? image) {
    if (image == null) return null;
    final bytes = image.readAsBytesSync();
    return base64Encode(bytes);
  }

  // Function to handle form submission
  Future<void> _submitForm() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final profileImageBase64 = _encodeImageToBase64(_selectedImage);

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all the fields.")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Passwords do not match."),

        ),
      );
      return;
    }
    try {
      final response = await http.post(
        Uri.parse(linkSignUp),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": name,
          "email": email,
          "password": password,
          "image_base": profileImageBase64,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const Login()),
        );
        if (isArabic!) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم إنشاء الحساب ، يرجى تسجيل الدخول!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Account Created, Please Login!")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    windowManager.setSize(const Size(860, 600));
    windowManager.setResizable(false);
    windowManager.setTitleBarStyle(TitleBarStyle.normal);
    windowManager.setTitle("Arabic Sign Language Project | Sign up");
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
                ],
              ),
            ),
          ),
          ListView(
            children: [
              const SizedBox(height: 80),
              Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!) : null,
                      child: _selectedImage == null
                          ? const Icon(Icons.add_a_photo, size: 45, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(isArabic! ? "الاسم" : "Name", nameController),
                  const SizedBox(height: 20),
                  _buildTextField(isArabic! ? "البريد الإلكتروني" : "Email", emailController),
                  const SizedBox(height: 20),
                  _buildTextField(isArabic! ? "كلمة المرور" : "Password", passwordController, isPassword: true),
                  const SizedBox(height: 20),
                  _buildTextField(isArabic! ? "تأكيد كلمة المرور" : "Confirm Password", confirmPasswordController, isPassword: true),
                  const SizedBox(height: 40),
                  Container(
                    height: 45,
                    width: 170,
                    decoration: const BoxDecoration(
                      color: Color(0xffBA33AB),
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                    child: MaterialButton(
                      onPressed: _submitForm,
                      child: Text(
                        isArabic! ? 'اشتراك' : 'Sign up',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 15,
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
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const choice()),
                  );
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

  // Helper function to build text fields
  Widget _buildTextField(String hintText, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 32,
        width: 300,
        child: TextField(
          controller: controller,
          textInputAction: controller == confirmPasswordController
              ? TextInputAction.done
              : TextInputAction.next,
          focusNode: controller == nameController
              ? _nameFocusNode
              : controller == emailController
              ? _emailFocusNode
              : controller == passwordController
              ? _passwordFocusNode
              : _confirmPasswordFocusNode,
          onSubmitted: (_) {
            if (controller == nameController) {
              FocusScope.of(context).requestFocus(_emailFocusNode);
            } else if (controller == emailController) {
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            } else if (controller == passwordController) {
              FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
            }
          },
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[600],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(8),
          ),
          obscureText: isPassword,
          style: const TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          cursorColor: Colors.blue,
          cursorWidth: 2,
          cursorRadius: const Radius.circular(4),
        ),
      ),
      
    );
  }
}
