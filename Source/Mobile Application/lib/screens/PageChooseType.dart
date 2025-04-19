import 'package:flutter/material.dart'; // For Material Design widgets
import 'package:sign_language_app/More_Data/Language.dart'; // Custom language data
import 'package:sign_language_app/main.dart';
import 'package:sign_language_app/screens/SignLanguageToWords.dart'; // Screen for sign language to words
import 'package:sign_language_app/screens/WordsToSignLanguage.dart'; // Screen for words to sign language
import 'package:sign_language_app/widgets/ChooseTypeMake.dart'; // Custom widget for choosing type
import 'dart:io'; // For file and directory operations
import 'package:video_player/video_player.dart'; // For video playback
import 'package:image_picker/image_picker.dart'; // For picking images from the camera or gallery

// Pagechoosetype widget for allowing users to choose between different modes
class Pagechoosetype extends StatefulWidget {
  // String userimage; // User's profile image URL or path
  final Function(bool) updatePageShow; // Function to update page visibility
  final Function
      updateshowbottomSignLanguageToWords; // Function to update bottom sheet visibility
  final Function updateHeight; // Function to update height
  bool pageshow; // Whether the page is visible
  bool isLoading; // Whether the app is in a loading state
  bool showbottomSignLanguageToWords; // Whether the bottom sheet is visible
  final TextEditingController
      textconvertController; // Controller for text input
  bool signlanguagetowords; // Whether the sign language to words mode is active
  bool wordstosignlanguage; // Whether the words to sign language mode is active
  bool learnletter; // Whether the learn letter mode is active
  bool isArabic; // Whether the app is in Arabic mode
  final Function(bool, bool, bool, bool, bool)
      updateVisibility; // Function to update visibility of modes

  dynamic reset_icon_logo; // Function to reset the icon/logo

  // Constructor for Pagechoosetype
  Pagechoosetype({
    super.key,
    required this.isArabic,
    required this.updateHeight,
    required this.updateshowbottomSignLanguageToWords,
    required this.updatePageShow,
    required this.isLoading,
    // required this.userimage,
    required this.pageshow,
    required this.textconvertController,
    required this.showbottomSignLanguageToWords,
    required this.reset_icon_logo,
    required this.signlanguagetowords,
    required this.wordstosignlanguage,
    required this.learnletter,
    required this.updateVisibility,
  });

  @override
  State<Pagechoosetype> createState() => _PagechoosetypeState();
}

// State class for Pagechoosetype
class _PagechoosetypeState extends State<Pagechoosetype> {
  @override
  void initState() {
    print("${sharedPref.getString("pfp_url")}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Visibility widget to conditionally show the content
        Visibility(
            visible: widget.signlanguagetowords == false &&
                    widget.wordstosignlanguage == false &&
                    widget.learnletter == false
                ? widget.pageshow
                : widget.showbottomSignLanguageToWords,
            child: Column(children: [
              // Stack for the user profile image and text
              SizedBox(
                height: 350,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // User profile image container
                    Center(
                        child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.3), // Shadow color
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              color: Color(
                                  0xFFD9D9D9), // Container background color
                              border: Border.all(
                                  color: Colors.black,
                                  width: 3), // Black border
                              borderRadius:
                                  BorderRadius.circular(120), // Circular shape
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(90),
                              child: sharedPref.getString("pfp_url") == 'null'
                                  ? Image.asset(
                                      "images/image_person_icon.png",
                                      fit: BoxFit.cover,
                                    )
                                  // CircularProgressIndicator(
                                  //     color: Color(
                                  //         0xFFBA33AB)) // Loading indicator
                                  : Image.network(
                                      "${sharedPref.getString("pfp_url")}", // Display user's profile image
                                      fit: BoxFit.cover,
                                    ),
                            ))),
                    SizedBox(
                      height: 40, // Spacing
                    ),
                    // Text positioned at the bottom of the stack
                    Positioned(
                      bottom: 50,
                      child: Text(
                        widget.isArabic
                            ? Arabic[11]
                            : English[11], // Text based on language
                        style: TextStyle(
                            fontFamily: widget.isArabic
                                ? "Arabic-sans"
                                : "Racing-sans", // Font based on language
                            fontSize: 20,
                            color: Colors.white), // Text color
                      ),
                    )
                  ],
                ),
              ),
              // Container for the mode selection buttons
              Container(
                  height: 350,
                  width: 310,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(15), // Rounded corners
                      color: Color.fromARGB(
                          255, 205, 205, 205)), // Container background color
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Button for Sign Language to Words mode
                      MaterialButton(
                          onPressed: () {
                            setState(() {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.grey.shade100,
                                    title: Text('Choose Media'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Please choose the type of media'),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                                widget
                                                    .reset_icon_logo(); // Reset the icon/logo
                                                widget.updateVisibility(
                                                    true,
                                                    false,
                                                    false,
                                                    false,
                                                    true); // Update visibility
                                                widget.updatePageShow(
                                                    false); // Hide the page
                                                widget
                                                    .updateshowbottomSignLanguageToWords(); // Update bottom sheet visibility
                                                widget
                                                    .updateHeight(); // Update height
                                              },
                                              child: Text(
                                                'Image',
                                                style: TextStyle(
                                                    color: Colors.deepPurple),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                                widget
                                                    .reset_icon_logo(); // Reset the icon/logo
                                                widget.updateVisibility(
                                                    true,
                                                    false,
                                                    false,
                                                    true,
                                                    false); // Update visibility
                                                widget.updatePageShow(
                                                    false); // Hide the page
                                                widget
                                                    .updateshowbottomSignLanguageToWords(); // Update bottom sheet visibility
                                                widget
                                                    .updateHeight(); // Update height
                                              },
                                              child: Text(
                                                'Live',
                                                style: TextStyle(
                                                    color: Colors.deepPurple),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            });
                          },
                          child: Choosetypemake(
                            icon: Icons
                                .sign_language_rounded, // Icon for the button
                            text: widget.isArabic
                                ? Arabic[12]
                                : English[12], // Text based on language
                            font: widget.isArabic
                                ? "Arabic-sans"
                                : "Racing-sans", // Font based on language
                          )),
                      // Button for Words to Sign Language mode
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            widget.reset_icon_logo(); // Reset the icon/logo
                            widget.updateVisibility(false, true, false, false,
                                false); // Update visibility
                            widget.updatePageShow(false); // Hide the page
                            widget
                                .updateshowbottomSignLanguageToWords(); // Update bottom sheet visibility
                            widget.updateHeight(); // Update height
                          });
                        },
                        child: Choosetypemake(
                          icon: Icons.text_fields, // Icon for the button
                          text: widget.isArabic
                              ? Arabic[13]
                              : English[13], // Text based on language
                          font: widget.isArabic
                              ? "Arabic-sans"
                              : "Racing-sans", // Font based on language
                        ),
                      ),
                      // Button for Learn Letter mode
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            widget.reset_icon_logo(); // Reset the icon/logo
                            widget.updateVisibility(false, false, true, false,
                                false); // Update visibility
                            widget.updatePageShow(false); // Hide the page
                            widget
                                .updateshowbottomSignLanguageToWords(); // Update bottom sheet visibility
                            widget.updateHeight(); // Update height
                          });
                        },
                        child: Choosetypemake(
                          icon: Icons.pin, // Icon for the button
                          text: widget.isArabic
                              ? Arabic[14]
                              : English[14], // Text based on language
                          font: widget.isArabic
                              ? "Arabic-sans"
                              : "Racing-sans", // Font based on language
                        ),
                      ),
                    ],
                  ))
            ])),
      ],
    );
  }
}
