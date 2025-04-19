import 'package:flutter/material.dart'; // For Material Design widgets
import 'package:sign_language_app/More_Data/Language.dart'; // Custom language data
import 'package:sign_language_app/widgets/ContainerButtonSettings.dart'; // Custom button widget for settings

// Settingspage widget for displaying and managing user settings
class Settingspage extends StatefulWidget {
  final String image; // User's profile image URL or path
  final String name; // User's name
  final String email; // User's email
  bool isArabic; // Whether the app is in Arabic mode
  Function updateisArabic; // Function to update the language state

  // Constructor for Settingspage
  Settingspage({
    Key? key,
    required this.updateisArabic,
    required this.image,
    required this.name,
    required this.email,
    required this.isArabic,
  }) : super(key: key);

  @override
  State<Settingspage> createState() => _SettingspageState();
}

// State class for Settingspage
class _SettingspageState extends State<Settingspage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: SafeArea(
        child: Column(
          children: [
            // Header container with a back button and title
            Container(
              height: 57,
              width: 340,
              decoration: BoxDecoration(
                  color: Color(0XFF747474), // Container background color
                  borderRadius: BorderRadius.circular(15)), // Rounded corners
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Navigate back when pressed
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white, // Back icon color
                      )),
                  const SizedBox(
                    width: 80, // Spacing
                  ),
                  Text(
                    widget.isArabic ? Arabic[25] : English[25], // Title text
                    style: TextStyle(
                        color: Colors.white, // Text color
                        fontFamily: widget.isArabic
                            ? "Arabic-sans"
                            : "Racing-sans", // Font based on language
                        fontSize: 23,
                        decorationColor: Color(0XFF747474)),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 40, // Spacing
            ),
            // User profile container
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: 140,
                width: 320,
                decoration: BoxDecoration(
                    color: Color(0XFF747474), // Container background color
                    borderRadius: BorderRadius.circular(10)), // Rounded corners
                child: Card(
                  color: Color(0XFF747474), // Card background color
                  child: Row(
                    children: [
                      // User profile image
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 110,
                            height: 120,
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
                              border: Border.all(
                                  color: Colors.black,
                                  width: 3), // Black border
                              borderRadius:
                                  BorderRadius.circular(120), // Circular shape
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(90),
                              child: widget.image == 'null'
                                  ? Image.asset(
                                      'images/image_person_icon.png', // Default profile image
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      widget.image, // User's profile image
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          )),
                      // User name and email
                      Expanded(
                        child: ListTile(
                          title: Text(
                            widget.name, // Display user's name
                            style: TextStyle(
                                fontFamily: "Racing-sans",
                                color: Colors.white), // Text style
                          ),
                          subtitle: Text(
                            widget.email, // Display user's email
                            style: TextStyle(
                                fontFamily: "Racing-sans",
                                color: Color.fromARGB(
                                    255, 155, 155, 155), // Subtitle color
                                fontSize: 10),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10, // Spacing
            ),
            // Language settings button
            Containerbuttonsettings(
              font: widget.isArabic
                  ? "Arabic-sans"
                  : "Racing-sans", // Font based on language
              text: widget.isArabic ? Arabic[29] : English[29], // Button text
              icon: Icons.language, // Language icon
              onPressed: () {
                // Show a dialog to switch language
                showDialog(
                  anchorPoint: Offset(20, 20),
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor:
                          Color(0XFF747474), // Dialog background color
                      title: Text(
                        widget.isArabic
                            ? Arabic[30]
                            : English[30], // Dialog title
                        style: TextStyle(
                            fontFamily: widget.isArabic
                                ? "Arabic-sans"
                                : "Racing-sans", // Font based on language
                            color: Colors.white), // Text color
                      ),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.isArabic
                                ? Arabic[31]
                                : English[31], // Language switch text
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: widget.isArabic
                                    ? "Arabic-sans"
                                    : "Racing-sans", // Font based on language
                                color: Colors.white), // Text color
                          ),
                          // Switch to toggle between Arabic and English
                          Switch(
                            activeColor: Colors.white, // Switch active color
                            value: widget.isArabic, // Current language state
                            onChanged: (value) {
                              setState(() {
                                widget.isArabic =
                                    value; // Update language state
                                widget
                                    .updateisArabic(); // Trigger language update
                                print(widget.isArabic); // Debug print
                              });
                              Navigator.of(context).pop(); // Close the dialog
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
