import 'dart:convert'; // For encoding/decoding data (e.g., base64)
import 'dart:ffi'; // For foreign function interface (not used in this code)
import 'dart:io'; // For file and directory operations

import 'package:flutter/cupertino.dart'; // For Cupertino widgets (iOS-style)
import 'package:flutter/gestures.dart'; // For gesture recognition
import 'package:flutter/material.dart'; // For Material Design widgets
import 'package:flutter/services.dart'; // For platform services (e.g., clipboard)
import 'package:flutter/widgets.dart'; // For basic Flutter widgets
import 'package:image_picker/image_picker.dart'; // For picking images from gallery/camera
import 'package:sign_language_app/More_Data/Language.dart'; // Custom language data
import 'package:sign_language_app/contscat/crud.dart'; // Custom CRUD operations
import 'package:sign_language_app/contscat/linksapp.dart'; // Custom API links
import 'package:sign_language_app/miniWidget/Validition.dart'; // Custom validation logic
import 'package:sign_language_app/screens/LoginScreen.dart'; // Login screen
import 'package:sign_language_app/screens/PageChooseType.dart'; // Screen for choosing type
import 'package:sign_language_app/widgets/ButtonSignupOrLogin.dart'; // Custom button widget
import 'package:sign_language_app/widgets/ContainerChooseOption.dart'; // Custom container widget
import 'package:sign_language_app/widgets/TextFieldApp.dart'; // Custom text field widget

// Signup screen widget
class Signupscreen extends StatefulWidget {
  final VoidCallback onSignupSuccess; // Callback when signup is successful
  Function updateshowbottomSignup; // Function to update bottom sheet visibility
  bool showbottomSignup; // Whether to show the bottom sheet
  bool isArabic; // Whether the app is in Arabic mode
  File? image; // Selected image file
  final TextEditingController nameController; // Controller for name input
  final TextEditingController emailController; // Controller for email input
  final TextEditingController
      passwordController; // Controller for password input
  final TextEditingController
      textconvertController; // Controller for text conversion
  dynamic reset_icon_logo; // Dynamic reset icon/logo
  bool isLoading; // Whether the app is in a loading state
  dynamic pickImageFromGallery; // Function to pick image from gallery
  dynamic pickImageFromCamera; // Function to pick image from camera
  final Function(bool, bool, bool, bool, bool)
      updateVisibility; // Function to update visibility

  // Constructor for Signupscreen
  Signupscreen({
    super.key,
    required this.isArabic,
    required this.isLoading,
    required this.updateshowbottomSignup,
    required this.onSignupSuccess,
    required this.pickImageFromCamera,
    required this.pickImageFromGallery,
    required this.showbottomSignup,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.textconvertController,
    required this.image,
    required this.reset_icon_logo,
    required this.updateVisibility,
  });

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

// State class for Signupscreen
class _SignupscreenState extends State<Signupscreen> {
  bool _showbutton = true; // Whether to show the add image button
  API api = API(); // Instance of CRUD operations

  Color color_confirm = Color(0xFF747474); // Color for confirm password icon
  IconData icon_confirm =
      Icons.visibility_off; // Icon for confirm password visibility
  GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Key for form validation

  final ImagePicker pickerr = ImagePicker(); // Instance of ImagePicker

  final TextEditingController _confirmpasswordController =
      TextEditingController(); // Controller for confirm password input

  // Function to handle signup
  void _signup() async {
    if (_formKey.currentState!.validate()) {
      // Validate form inputs
      if (widget.image == null) {
        // Check if an image is selected
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isArabic ? "أدخل الصورة" : 'Please select an image',
              style: TextStyle(
                  fontFamily: widget.isArabic ? "Arabic-sans" : "Racing-sans"),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      widget.isLoading = true; // Set loading state to true
      setState(() {});

      Uint8List imageBytes =
          await widget.image!.readAsBytes(); // Read image as bytes
      var response = await api.postRequest(linkSignUp, {
        // Send signup request
        "image_base": base64Encode(imageBytes), // Encode image to base64
        "username": widget.nameController.text, // Get username
        "email": widget.emailController.text, // Get email
        "password": widget.passwordController.text, // Get password
      });

      widget.isLoading = false; // Set loading state to false
      setState(() {});

      if (response?['message'] == 'Account created') {
        // Check if account creation was successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isArabic ? "تم انشاء الحساب" : response?['message'],
              style: TextStyle(
                  fontFamily: widget.isArabic ? "Arabic-sans" : 'Racing-sans'),
            ),
            backgroundColor: Color(0xFFBA33AB),
          ),
        );
        widget.onSignupSuccess(); // Trigger success callback
      } else {
        // Handle signup failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isArabic
                  ? "فشل انشاء الحساب"
                  : response?['message'] ?? "Eroor",
              style: TextStyle(
                  fontFamily: widget.isArabic ? "Arabic-sans" : 'Racing-sans'),
            ),
          ),
        );
      }
    }
  }

  bool _pagechoose = false; // Whether to show page choose options
  bool _obscureText = true; // Whether to obscure password text
  bool _showBottom = true; // Whether to show the bottom sheet

  PersistentBottomSheetController?
      bottomSheetController; // Controller for bottom sheet

  // Function to show bottom sheet for image selection
  void _showBottomSheet() {
    showBottomSheet(
      context: context,
      elevation: 20,
      builder: (context) {
        return Visibility(
          visible: widget.showbottomSignup,
          child: Container(
            height: 336,
            width: 310,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 3,
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      height: 5,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Containerchooseoption(
                    text: widget.isArabic ? Arabic[18] : English[18],
                    font: widget.isArabic ? "Arabic-sans" : "Racing-sans",
                    onPressed: widget.pickImageFromGallery,
                    icon: Icons.photo_library_outlined),
                SizedBox(
                  height: 40,
                ),
                Containerchooseoption(
                    text: widget.isArabic ? Arabic[7] : English[7],
                    font: widget.isArabic ? "Arabic-sans" : "Racing-sans",
                    onPressed: widget.pickImageFromCamera,
                    icon: Icons.photo_camera),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to close the bottom sheet
  void _closeBottom() {
    setState(() {
      widget.showbottomSignup = !widget.showbottomSignup;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 120),
        Center(
          child: Stack(
            children: [
              Container(
                height: 190,
                width: 190,
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
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(120),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: widget.image == null
                      ? Image.asset(
                          'images/image_person_icon.png',
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          widget.image!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Visibility(
                visible: _showbutton,
                child: Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFBA33AB),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _showBottomSheet();
                          _closeBottom();
                        });
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Form(
          key: _formKey,
          child: Column(children: [
            SizedBox(
              height: 40,
            ),
            TextFieldApp(
              font: widget.isArabic ? "Arabic-sans" : "Racing-sans",
              Name: widget.isArabic ? Arabic[2] : English[2],
              Type: TextInputType.name,
              PrefixIcon: Icon(Icons.abc_outlined),
              obs: false,
              controller: widget.nameController,
              validator: (value) {
                return Vaild(value!, 2, 8);
              },
            ),
            SizedBox(height: 10),
            TextFieldApp(
              font: widget.isArabic ? "Arabic-sans" : "Racing-sans",
              Name: widget.isArabic ? Arabic[3] : English[3],
              Type: TextInputType.emailAddress,
              PrefixIcon: Icon(Icons.email_outlined),
              obs: false,
              controller: widget.emailController,
              validator: (value) {
                return Vaild(value!, 11, 23);
              },
            ),
            SizedBox(height: 10),
            TextFieldApp(
              font: widget.isArabic ? "Arabic-sans" : "Racing-sans",
              Name: widget.isArabic ? Arabic[4] : English[4],
              Type: TextInputType.number,
              PrefixIcon: Icon(Icons.password_outlined),
              obs: false,
              controller: widget.passwordController,
              validator: (value) {
                return Vaild(value!, 4, 8);
              },
            ),
            SizedBox(height: 10),
            Row(children: [
              Padding(
                padding: EdgeInsets.only(left: 55),
                child: TextFieldApp(
                  font: widget.isArabic ? "Arabic-sans" : "Racing-sans",
                  Name: widget.isArabic ? Arabic[5] : English[5],
                  Type: TextInputType.number,
                  PrefixIcon: Icon(Icons.password_outlined),
                  obs: _obscureText,
                  controller: _confirmpasswordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return widget.isArabic
                          ? "من فضلك أدخل كلمه المرور"
                          : 'Please enter your password';
                    } else if (value != widget.passwordController.text) {
                      return widget.isArabic
                          ? "من فضلك أدخل كلمه المرور صحيحه"
                          : 'Please enter password correct';
                    } else if (value.length < 4) {
                      return widget.isArabic
                          ? "يجب أن تكون أكبر من 4"
                          : 'Should be bigger than 4 ';
                    } else if (value.length > 8) {
                      return widget.isArabic
                          ? "يجب أن تكون أصغر من 8"
                          : 'Should be smaller than 8 ';
                    }
                  },
                ),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                      if (_obscureText == true) {
                        color_confirm = Color.fromARGB(255, 151, 156, 156);
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
                  ))
            ]),
          ]),
        ),
        SizedBox(height: 30),
        widget.isLoading == true
            ? Center(
                child: CircularProgressIndicator(
                color: Color(0xFFBA33AB),
              ))
            : Buttonsignuporlogin(
                onPressed: _signup,
                text: widget.isArabic ? Arabic[0] : English[0],
                font: widget.isArabic ? "Arabic-sans" : "Racing-sans",
                icon: Icons.note_add_rounded)
      ],
    );
  }
}
