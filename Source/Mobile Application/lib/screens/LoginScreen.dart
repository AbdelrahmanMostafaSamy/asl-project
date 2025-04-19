import 'package:awesome_dialog/awesome_dialog.dart'; // For displaying custom dialogs
import 'package:flutter/material.dart'; // For Material Design widgets
import 'package:sign_language_app/More_Data/Language.dart'; // Custom language data
import 'package:sign_language_app/contscat/crud.dart'; // Custom CRUD operations
import 'package:sign_language_app/contscat/linksapp.dart'; // Custom API links
import 'package:sign_language_app/main.dart'; // Main application file
import 'package:sign_language_app/miniWidget/Validition.dart'; // Custom validation logic
import 'package:sign_language_app/screens/PageChooseType.dart'; // Screen for choosing type
import 'package:sign_language_app/widgets/ButtonSignupOrLogin.dart'; // Custom button widget
import 'package:sign_language_app/widgets/TextFieldApp.dart'; // Custom text field widget
import 'dart:io'; // For file and directory operations

// Login screen widget
class Loginscreen extends StatefulWidget {
  final VoidCallback onLoginSuccess; // Callback when login is successful
  final TextEditingController
      textconvertController; // Controller for text conversion
  File? image; // Selected image file
  bool isLoading; // Whether the app is in a loading state
  final TextEditingController nameController; // Controller for name input
  final TextEditingController
      passwordController; // Controller for password input
  bool isArabic; // Whether the app is in Arabic mode

  // Constructor for Loginscreen
  Loginscreen({
    super.key,
    required this.isArabic,
    required this.isLoading,
    required this.onLoginSuccess,
    required this.textconvertController,
    required this.nameController,
    required this.passwordController,
    required this.image,
  });

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

// State class for Loginscreen
class _LoginscreenState extends State<Loginscreen> {
  GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Key for form validation

  final TextEditingController _emailController =
      TextEditingController(); // Controller for email input
  final TextEditingController _passwordController =
      TextEditingController(); // Controller for password input
  Color color_confirm = Colors.grey; // Color for password visibility icon
  IconData icon_confirm = Icons.visibility_off; // Icon for password visibility
  bool _logini = true; // Whether to show the login form
  bool _pagechoose = false; // Whether to show page choose options
  bool _obscureText = true; // Whether to obscure password text
  bool isLoding = false; // Whether the app is in a loading state
  API api = API(); // Instance of CRUD operations

  // Function to handle login
  void _login() async {
    if (_formKey.currentState!.validate()) {
      // Validate form inputs
      widget.isLoading = true; // Set loading state to true
      if (mounted) setState(() {});

      var response = await api.postRequest(linkLogin, {
        // Send login request
        "email": _emailController.text, // Get email
        "password": _passwordController.text, // Get password
      });

      widget.isLoading = false; // Set loading state to false
      if (mounted) setState(() {});

      if (response?['message'] == 'Correct') {
        // Check if login was successful
        sharedPref.setString("id",
            response!['id'].toString()); // Save user ID to shared preferences
        sharedPref.setString("pfp_url",
            response!['pfp_url'].toString()); // Save profile picture URL
        sharedPref.setString(
            "username", response!['username']); // Save username
        sharedPref.setString("email", response!['email']); // Save email
        print("Login sucsess: ${response?['message']}");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 1),
            content: Text(
              widget.isArabic ? "تسجيل ناجح" : 'Login Sucsessful',
              style: TextStyle(
                  fontFamily: widget.isArabic ? 'Arabic-sans' : 'Racing-sans'),
            ),
            backgroundColor: Color(0xFFBA33AB),
          ),
        );
        widget.onLoginSuccess(); // Notify the parent widget of successful login
      } else {
        // Handle login failure
        print("Login failed: ${response?['message']}");
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: widget.isArabic ? "مشكله" : 'Error',
          desc: widget.isArabic
              ? "اسم المستخدم أو كلمه المرور غير صحيحه"
              : 'Username or password incorrect',
          btnOkOnPress: () {},
          dialogBackgroundColor: Color(0xFFBA33AB),
          titleTextStyle: TextStyle(
              color: Colors.white,
              fontFamily: widget.isArabic ? "Arabic-sans" : "Racing-sans"),
          descTextStyle: TextStyle(
              color: Colors.white,
              fontFamily: widget.isArabic ? "Arabic-sans" : "Racing-sans"),
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: _logini,
          child: Column(
            children: [
              SizedBox(height: 130),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                      color: Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(21)),
                  child:
                      Image.asset("images/ASLP Logo4.png"), // Display app logo
                ),
              ),
              SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 50, right: 45),
                        child: TextFieldApp(
                          font: widget.isArabic ? "Arabic-sans" : "Racing-sans",
                          Name: widget.isArabic ? Arabic[3] : English[3],
                          Type: TextInputType.name,
                          PrefixIcon: Icon(
                            Icons.email,
                          ),
                          obs: false,
                          controller: _emailController,
                          validator: (value) {
                            return Vaild(
                                value!, 11, 23); // Validate email input
                          },
                        )),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 59, right: 10),
                              child: TextFieldApp(
                                Name: widget.isArabic ? Arabic[4] : English[4],
                                font: widget.isArabic
                                    ? "Arabic-sans"
                                    : "Racing-sans",
                                Type: TextInputType.number,
                                PrefixIcon: Icon(
                                  Icons.lock,
                                ),
                                obs: _obscureText,
                                controller: _passwordController,
                                validator: (value) {
                                  return Vaild(
                                      value!, 4, 8); // Validate password input
                                },
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 50.0),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText =
                                    !_obscureText; // Toggle password visibility
                                if (_obscureText) {
                                  color_confirm =
                                      Color.fromARGB(255, 151, 156, 156);
                                  icon_confirm = Icons.visibility_off;
                                } else {
                                  color_confirm = Color(0xFFBA33AB);
                                  icon_confirm = Icons.visibility;
                                }
                              });
                            },
                            icon: Icon(
                              icon_confirm,
                              color: color_confirm,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    widget.isLoading == true
                        ? Center(
                            child: CircularProgressIndicator(
                            color: Color(0xFFBA33AB), // Show loading indicator
                          ))
                        : Buttonsignuporlogin(
                            onPressed: _login,
                            text: widget.isArabic ? Arabic[1] : English[1],
                            font:
                                widget.isArabic ? "Arabic-sans" : "Racing-sans",
                            icon: Icons.login_rounded) // Login button
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
