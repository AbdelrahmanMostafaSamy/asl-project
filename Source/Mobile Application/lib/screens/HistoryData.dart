import 'package:flutter/material.dart'; // For Material Design widgets
import 'package:sign_language_app/More_Data/Language.dart'; // Custom language data

// Historydata widget for displaying detailed information about a specific history item
class Historydata extends StatelessWidget {
  String image; // Image URL or path for the history item
  String date; // Date of the history item
  String result; // Result of the history item (e.g., prediction)
  String type; // Type of the history item (e.g., "Sign Language To Words")
  bool isArabic; // Whether the app is in Arabic mode

  // Constructor for Historydata
  Historydata({
    super.key,
    required this.image,
    required this.date,
    required this.result,
    required this.type,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background image container
            Positioned(
              top: 190, // Position from the top
              left: 20,
              right: 20,
              bottom: 50,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white, // White background
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                    border: Border.all(
                        color: const Color(0XFF747474),
                        width: 6)), // Grey border
                child: Image.asset(
                  "images/v1066-069c 1.png", // Background image
                  height: 50,
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(width: 650), // Spacing
                // Header container with a back button and title
                Container(
                  height: 57,
                  width: 340,
                  decoration: BoxDecoration(
                    color:
                        const Color(0XFF747474), // Container background color
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // Navigate back when pressed
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white, // Back icon color
                        ),
                      ),
                      SizedBox(width: 93), // Spacing
                      Text(
                        isArabic ? Arabic[33] : English[33], // Title text
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontFamily: isArabic
                              ? "Arabic-sans"
                              : "Racing-sans", // Font based on language
                          fontSize: 23,
                        ),
                      ),
                      const Spacer(), // Spacer to push the title to the center
                    ],
                  ),
                ),
                const SizedBox(height: 40), // Spacing
                // Container for displaying the history image
                Container(
                  height: 400,
                  width: 280,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color(0XFF747474),
                        width: 7), // Grey border
                    color: Colors.white, // Container background color
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  child: image.isEmpty
                      ? CircularProgressIndicator(
                          color: Colors.grey, // Loading indicator
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Image.network(
                            image, // Display the history image from the network
                          ),
                        ),
                ),
                const SizedBox(height: 40), // Spacing

                // Container for displaying history details
                Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                    color:
                        const Color(0XFF747474), // Container background color
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Row to display the type of history
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              isArabic
                                  ? "${Arabic[34]} : " // Label in Arabic
                                  : "${English[34]} : ", // Label in English
                              style: TextStyle(
                                color: Colors.white, // Text color
                                fontSize: 15,
                                fontFamily: isArabic
                                    ? "Arabic-sans"
                                    : "Racing-sans", // Font based on language
                              ),
                            ),
                            SizedBox(
                              width: 10, // Spacing
                            ),
                            Text(
                              type == "Sign Language To Words"
                                  ? isArabic
                                      ? Arabic[12] // Type in Arabic
                                      : English[12] // Type in English
                                  : isArabic
                                      ? Arabic[13] // Type in Arabic
                                      : English[13], // Type in English
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                        // Row to display the date of the history
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              isArabic
                                  ? "${Arabic[39]} : " // Label in Arabic
                                  : "${English[39]} : ", // Label in English
                              style: TextStyle(
                                color: Colors.white, // Text color
                                fontSize: 20,
                                fontFamily: isArabic
                                    ? "Arabic-sans"
                                    : "Racing-sans", // Font based on language
                              ),
                            ),
                            SizedBox(
                              width: 50, // Spacing
                            ),
                            Text(
                              date.substring(0,
                                  10), // Display the date (first 10 characters)
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                        // Row to display the time of the history
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              isArabic
                                  ? "الساعه : " // Label in Arabic
                                  : "Time : ", // Label in English
                              style: TextStyle(
                                color: Colors.white, // Text color
                                fontSize: 20,
                                fontFamily: isArabic
                                    ? "Arabic-sans"
                                    : "Racing-sans", // Font based on language
                              ),
                            ),
                            SizedBox(
                              width: 50, // Spacing
                            ),
                            Text(
                              date.substring(11,
                                  16), // Display the time (characters 11 to 16)
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                        // Row to display the result of the history
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              isArabic
                                  ? "${Arabic[36]} : " // Label in Arabic
                                  : "${English[36]} : ", // Label in English
                              style: TextStyle(
                                color: Colors.white, // Text color
                                fontSize: 20,
                                fontFamily: isArabic
                                    ? "Arabic-sans"
                                    : "Racing-sans", // Font based on language
                              ),
                            ),
                            SizedBox(
                              width: 50, // Spacing
                            ),
                            Expanded(
                              child: Text(
                                result, // Display the result
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                                maxLines: 5, // Limit the number of lines
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
