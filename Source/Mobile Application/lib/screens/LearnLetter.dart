import 'dart:io'; // For file and directory operations
import 'dart:typed_data'; // For handling byte data
import 'dart:convert'; // For encoding/decoding data (e.g., base64)
import 'package:flutter/material.dart'; // For Material Design widgets
import 'package:image_picker/image_picker.dart'; // For picking images from the camera or gallery
import 'package:sign_language_app/contscat/crud.dart'; // Custom CRUD operations
import 'package:sign_language_app/contscat/linksapp.dart'; // Custom API links
import 'package:sign_language_app/main.dart'; // Main application file
import 'package:sign_language_app/screens/ShowLetter.dart'; // Screen to display letter details
import 'package:sign_language_app/widgets/ButtonMode.dart'; // Custom button widget
import 'package:sign_language_app/widgets/CheckTrueOrFalse.dart'; // Custom widget for displaying check status
import 'package:sign_language_app/widgets/IconButtonApp.dart'; // Custom icon button widget

// Learnletter widget for teaching a specific sign language letter
class Learnletter extends StatefulWidget {
  String Image; // Image path for the letter
  String Done; // Status of learning (True, False, or None)
  List<Map<String, dynamic>> data; // Data related to the letter
  String Letter; // The letter being learned
  bool isLoading; // Whether the app is in a loading state

  // Constructor for Learnletter
  Learnletter({
    super.key,
    required this.Done,
    required this.Image,
    required this.Letter,
    required this.isLoading,
    required this.data,
  });

  @override
  State<Learnletter> createState() => _LearnletterState();
}

// State class for Learnletter
class _LearnletterState extends State<Learnletter> {
  String check1 = "None"; // Status of the first attempt
  String check2 = "None"; // Status of the second attempt
  String check3 = "None"; // Status of the third attempt
  String check4 = "None"; // Status of the fourth attempt
  String check5 = "None"; // Status of the fifth attempt
  bool button = true; // Whether the check button is enabled
  API api = API(); // Instance of api operations

  @override
  void initState() {
    super.initState();
    // Initialize the check status based on the Done value
    if (widget.Done == 'False') {
      check1 = 'False';
      check2 = 'False';
      check3 = 'False';
      check4 = 'False';
      check5 = 'False';
      button = false; // Disable the button if learning is already done
    } else if (widget.Done == 'True') {
      check1 = 'True';
      check2 = 'True';
      check3 = 'True';
      check4 = 'True';
      check5 = 'True';
      button = false; // Disable the button if learning is already done
    }
  }

  // Function to update the learning status in the database
  checkLearn(String Letter, String Done) async {
    var response = await api.postRequest(linkLearn,
        {'letter': Letter, 'id': sharedPref.getString('id'), "done": Done});
  }

  // Function to check the user's attempt
  check() async {
    setState(() {
      widget.isLoading = true; // Set loading state to true
    });
    if (_cameraImage == null) {
      // Check if an image is selected
      setState(() {
        widget.isLoading = false; // Set loading state to false
      });
      _showSnackBar('أدخل صورة أولا'); // Show error message
      return;
    }

    try {
      Uint8List bytes =
          await _cameraImage!.readAsBytes(); // Read image as bytes
      setState(() {
        widget.isLoading = true; // Set loading state to true
      });

      // Send the image to the API for prediction
      var response = await api.postRequest(LinkModel, {
        'image': base64Encode(bytes),
        'type': 'learn',
        'id': sharedPref.getString('id')
      });
      setState(() {
        widget.isLoading = false; // Set loading state to false
      });

      if (response == null) {
        // Handle null response
        setState(() {
          _cameraImage = null; // Clear the selected image
          count += 1; // Increment the attempt count
          // Update the check status based on the attempt count
          if (count == 1) {
            check1 = "False";
          } else if (count == 2) {
            check2 = "False";
          } else if (count == 3) {
            check3 = "False";
          } else if (count == 4) {
            check4 = "False";
          } else if (count == 5) {
            check5 = "False";
          }
        });
        setState(() {
          if (count == 5) {
            // If all attempts are used
            button = false; // Disable the button
            int trueCount = [check1, check2, check3, check4, check5]
                .where((c) => c == 'True')
                .length;
            // Check if the learning is successful based on the check status

            if (trueCount >= 3) {
              checkLearn(widget.Letter, "True"); // Mark learning as successful
            } else {
              checkLearn(widget.Letter, "False"); // Mark learning as failed
            }
          }
        });
        return;
      } else if (response['prediction'] != null) {
        // Handle successful response
        if (response['prediction'] == widget.Letter) {
          // Check if the prediction matches the letter
          _showSnackBar(
              '${response['prediction']} : الناتج  '); // Show success message
          setState(() {
            _cameraImage = null; // Clear the selected image
            count += 1; // Increment the attempt count
            // Update the check status based on the attempt count
            if (count == 1) {
              check1 = "True";
            } else if (count == 2) {
              check2 = "True";
            } else if (count == 3) {
              check3 = "True";
            } else if (count == 4) {
              check4 = "True";
            } else if (count == 5) {
              check5 = "True";
            }
          });
        } else {
          // Handle incorrect prediction
          setState(() {
            _cameraImage = null; // Clear the selected image
            count += 1; // Increment the attempt count
            // Update the check status based on the attempt count
            if (count == 1) {
              check1 = "False";
            } else if (count == 2) {
              check2 = "False";
            } else if (count == 3) {
              check3 = "False";
            } else if (count == 4) {
              check4 = "False";
            } else if (count == 5) {
              check5 = "False";
            }
          });
        }
        setState(() {
          if (count == 5) {
            // If all attempts are used
            button = false; // Disable the button
            int trueCount = [check1, check2, check3, check4, check5]
                .where((c) => c == 'True')
                .length;
            // Check if the learning is successful based on the check status

            if (trueCount >= 3) {
              checkLearn(widget.Letter, "True"); // Mark learning as successful
            } else {
              checkLearn(widget.Letter, "False"); // Mark learning as failed
            }
          }
        });
      } else {
        // Handle unexpected response
        _showSnackBar('Unexpected response');
      }
    } catch (e) {
      // Handle exceptions
      setState(() {
        widget.isLoading = false; // Set loading state to false
      });
      _showSnackBar('An error occurred: $e'); // Show error message
    }
  }

  // Function to show a snackbar with a message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 1),
        content: Text(
          message,
          style: TextStyle(
              fontFamily: 'Arabic-sans'), // Arabic font for the message
        ),
        backgroundColor: Colors.black,
      ),
    );
  }

  int count = 0; // Counter for the number of attempts

  final ImagePicker pickerr = ImagePicker(); // Instance of ImagePicker
  File? _cameraImage; // Selected image file

  // Function to pick an image from the camera
  _pickImageFromCamera() async {
    final XFile? pickedFile = await pickerr.pickImage(
      source: ImageSource.camera,
      imageQuality: 50, // Set image quality
    );

    if (pickedFile != null) {
      // If an image is selected
      setState(() {
        _cameraImage = File(pickedFile.path); // Set the selected image
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black, // Set background color to black
            body: SingleChildScrollView(
              child: Column(children: [
                Center(
                  child: Container(
                    height: 57,
                    width: 360,
                    decoration: BoxDecoration(
                        color: const Color(
                            0XFF747474), // Container background color
                        borderRadius:
                            BorderRadius.circular(15)), // Rounded corners
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop(true); // Navigate back
                            count = 0; // Reset the attempt counter
                            _cameraImage = null; // Clear the selected image
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 70),
                        Center(
                          child: Text(
                            "تعلم حرف ${widget.Letter}", // Title text
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Arabic-sans", // Arabic font
                              fontSize: 27,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                    height: 400,
                    width: 280,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0XFF747474),
                            width: 7), // Border for the container
                        color: Colors.white, // Container background color
                        borderRadius:
                            BorderRadius.circular(20)), // Rounded corners
                    child: _cameraImage == null
                        ? ClipRRect(
                            child: Image.asset(
                                "images/ASLP Logo4.png"), // Default image
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Image.file(
                              _cameraImage!, // Display the selected image
                              fit: BoxFit.cover,
                            ),
                          )),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Iconbuttonapp(
                        color:
                            const Color(0XFF747474), // Button background color
                        colorIcon: Colors.white, // Icon color
                        icon: Icons
                            .file_open, // Icon for opening the letter details
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Showletter(
                                image: widget.Image,
                                Letter: widget
                                    .Letter), // Navigate to Showletter screen
                          ));
                        }),
                    SizedBox(
                      width: 30,
                    ),
                    Iconbuttonapp(
                        color:
                            const Color(0XFF747474), // Button background color
                        colorIcon: Colors.white, // Icon color
                        icon: Icons.add, // Icon for adding an image
                        onPressed: () {
                          if (widget.Done == 'False' ||
                              widget.Done == 'True' ||
                              button == false) {
                            Container(); // Do nothing if learning is already done
                          } else {
                            _pickImageFromCamera(); // Pick an image from the camera
                          }
                        }),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 70,
                  width: 270,
                  decoration: BoxDecoration(
                      color:
                          const Color(0XFF747474), // Container background color
                      borderRadius:
                          BorderRadius.circular(20)), // Rounded corners
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Checktrueorfalse(
                          check: check1, // Status of the first attempt
                          count: count, // Current attempt count
                        ),
                        Checktrueorfalse(
                            check: check2,
                            count: count), // Status of the second attempt
                        Checktrueorfalse(
                            check: check3,
                            count: count), // Status of the third attempt
                        Checktrueorfalse(
                            check: check4,
                            count: count), // Status of the fourth attempt
                        Checktrueorfalse(
                            check: check5,
                            count: count), // Status of the fifth attempt
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                widget.isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white, // Loading indicator
                      )
                    : Visibility(
                        visible: button, // Show the button only if it's enabled
                        child: Buttonmode(
                          font: "Arabic-sans", // Arabic font
                          text: "التحقق", // Button text
                          color: Colors.white, // Text color
                          icon: Icons.check_circle, // Icon for the button
                          backgroundcolor: const Color(
                              0XFF747474), // Button background color
                          onPressed: () =>
                              check(), // Function to call when the button is pressed
                          height: 50, // Button height
                          width: 140, // Button width
                        ),
                      ),
              ]),
            )));
  }
}
