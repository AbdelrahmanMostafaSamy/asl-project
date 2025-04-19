import 'package:flutter/material.dart'; // For Material Design widgets
import 'package:sign_language_app/More_Data/Language.dart'; // Custom language data
import 'package:sign_language_app/contscat/crud.dart'; // Custom api operations
import 'package:sign_language_app/contscat/linksapp.dart'; // Custom API links
import 'package:sign_language_app/main.dart'; // Main application file
import 'package:sign_language_app/miniWidget/Validition.dart'; // Custom validation logic
import 'package:sign_language_app/widgets/ButtonMode.dart'; // Custom button widget
import 'package:sign_language_app/widgets/ContainerChooseOption.dart'; // Custom container widget
import 'package:sign_language_app/widgets/IconButtonApp.dart'; // Custom icon button widget
import 'package:sign_language_app/widgets/TextFieldApp.dart'; // Custom text field widget
import 'package:url_launcher/url_launcher.dart'; // For launching URLs
import 'LetterData.dart'; // Custom widget for displaying letter data

// Wordstosignlanguage widget for converting words to sign language
class Wordstosignlanguage extends StatefulWidget {
  final TextEditingController
      textconvertController; // Controller for text input
  final dynamic
      updateShowBottomLetters; // Function to update bottom sheet visibility
  bool isArabic; // Whether the app is in Arabic mode
  bool showbottomLetters; // Whether to show the bottom sheet for letters

  // Constructor for Wordstosignlanguage
  Wordstosignlanguage({
    super.key,
    required this.updateShowBottomLetters,
    required this.showbottomLetters,
    required this.textconvertController,
    required this.isArabic,
  });

  @override
  State<Wordstosignlanguage> createState() => _WordstosignlanguageState();
}

// State class for Wordstosignlanguage
class _WordstosignlanguageState extends State<Wordstosignlanguage> {
  API api = API(); // Instance of api operations
  String Gif = "images/ASLP Logo4.png"; // Default GIF image
  List<Map<String, dynamic>> LettersList = []; // List to store fetched letters

  // Function to fetch letters from the API
  dynamic fetchLetters() async {
    var response =
        await api.getRequest(LinkGetLetters); // Fetch letters from API

    if (response == null) {
      // Handle null response
      setState(() {
        LettersList = [];
      });
    } else {
      // Process response
      setState(() {
        LettersList = List<Map<String, dynamic>>.from(response['data'].map(
            (item) => {
                  'word': item[0],
                  'image': item[1]
                })); // Map response data to list

        print("$LettersList"); // Print fetched letters for debugging
      });
    }
  }

  // Function to convert text to sign language
  Future<void> Convert(String sentence) async {
    var response = await api.postRequest(
      linkTextToSign, // API endpoint for text-to-sign conversion
      {'id': sharedPref.getString('id'), "sentence": sentence}, // Request body
    );

    if (sentence.isEmpty) {
      // Handle empty input
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            duration: Duration(seconds: 1),
            content: Text(
              widget.isArabic ? "لو سمحت أدخل الكلمات" : 'Please enter a words',
              style: TextStyle(
                  fontFamily: widget.isArabic ? "Arabic-sans" : "Racing-sans"),
            )),
      );
    }
    setState(() {
      if (response == null || response['message'] == "ُNot Found in DataBase") {
        Gif = "images/ASLP Logo4.png"; // Default image if no result is found
      } else if (response['message'] == 'Correct') {
        Gif = response['file_name']; // Set GIF image from response
        print(Gif); // Print GIF path for debugging
      }
    });
  }

  // Function to launch the WhatsApp group link
  Future<void> _launchAboutPage() async {
    final Uri url = Uri.parse(
        'https://chat.whatsapp.com/GAgm3l2a1zNISYsVYHuWM7'); // WhatsApp group link
    try {
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // Launch in external application
      )) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLetters(); // Fetch letters when the widget is initialized
  }

  // Function to show the bottom sheet for selecting letters
  void _choose_camera_or_gallery() {
    showBottomSheet(
      context: context,
      builder: (context) {
        return Visibility(
          visible: widget.showbottomLetters,
          child: Container(
              height: 480,
              width: 370,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black, width: 3), // Border for the container
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                  child: Column(children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                          onPressed: () {
                            widget
                                .updateShowBottomLetters(); // Update bottom sheet visibility
                            Navigator.pop(context); // Close the bottom sheet
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.black,
                          )),
                    )
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: LettersList.length, // Number of letters
                  itemBuilder: (context, index) {
                    var letterItem = LettersList[index]; // Current letter

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            // Display the letter image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(letterItem['image'],
                                  height: 60, width: 60, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 15),
                            // Display the letter word
                            Expanded(
                              child: Text(
                                letterItem['word'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: widget.isArabic
                                      ? "Arabic-sans"
                                      : "Racing-sans",
                                ),
                              ),
                            ),

                            // Button to play the letter video
                            IconButton(
                              icon: Icon(Icons.play_circle_fill,
                                  color: Colors.blue, size: 35),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => LetterData(
                                        letter:
                                            "${letterItem['image']}"), // Navigate to LetterData screen
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ]))),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 110),
            Container(
              height: 430,
              width: 331,
              decoration: BoxDecoration(
                color: const Color(0XFF9F9D9D),
                border: Border.all(color: Colors.black, width: 4),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Container(
                height: 400,
                width: 280,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  child: Gif == "images/ASLP Logo4.png"
                      ? Image.asset(Gif) // Display default image
                      : Image.network(Gif), // Display fetched GIF
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFieldApp(
              font: widget.isArabic ? "Arabic-sans" : "Racing-sans",
              Name: widget.isArabic ? Arabic[20] : English[20],
              Type: TextInputType.name,
              PrefixIcon: const Icon(
                Icons.text_fields_outlined,
                color: Colors.black,
              ),
              obs: false,
              controller:
                  widget.textconvertController, // Controller for text input
              validator: (val) {
                return Vaild(val!, 1, 90); // Validate text input
              },
            ),
            const SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(left: 100),
              child: Row(
                children: [
                  Buttonmode(
                    font: widget.isArabic ? "Arabic-sans" : "Racing-sans",
                    height: 60,
                    width: 160,
                    text: widget.isArabic ? Arabic[21] : English[21],
                    color: Colors.white,
                    icon: Icons.swap_horizontal_circle,
                    backgroundcolor: const Color(0XFFBA33AB),
                    onPressed: () {
                      Convert(widget.textconvertController
                          .text); // Convert text to sign language
                    },
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Iconbuttonapp(
                      color: Colors.grey,
                      colorIcon: Colors.white,
                      icon: Icons.menu_book_outlined,
                      onPressed: () {
                        widget
                            .updateShowBottomLetters(); // Update bottom sheet visibility
                        fetchLetters(); // Fetch letters
                        _choose_camera_or_gallery(); // Show bottom sheet
                      })
                ],
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                onPressed: _launchAboutPage, // Launch WhatsApp group link
                child: Text(
                  widget.isArabic ? Arabic[22] : English[22],
                  style: TextStyle(
                    fontFamily: widget.isArabic ? "Arabic-sans" : "Racing-sans",
                    color: const Color(0xFFBA33AB),
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xFFBA33AB),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
