import 'package:flutter/material.dart'; // For Material Design widgets

// LetterData widget for displaying a specific letter's image
class LetterData extends StatelessWidget {
  final String letter; // The URL or path of the letter image to display

  // Constructor for LetterData
  LetterData({super.key, required this.letter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: SafeArea(
        child: Stack(
          children: [
            // Background image container
            Center(
              child: Container(
                  width: double.infinity, // Full width
                  height: double.infinity, // Full height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  child: Image.asset(
                      "images/v1066-069c 1.png")), // Background image
            ),
            // Back button positioned at the top-left corner
            Positioned(
              top: 15,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_back,
                    size: 30, color: Colors.black), // Back icon
                onPressed: () =>
                    Navigator.pop(context), // Navigate back when pressed
              ),
            ),
            // Container for displaying the letter image
            Positioned(
                top: 160,
                left: 50,
                child: Container(
                    height: 450,
                    width: 290,
                    decoration: BoxDecoration(
                        color: Colors.white, // Container background color
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                        border: Border.all(
                            color: Colors.grey, width: 5)), // Grey border
                    child: Image.network(
                        letter))) // Display the letter image from the network
          ],
        ),
      ),
    );
  }
}
