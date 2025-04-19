import 'package:flutter/material.dart'; // For Material Design widgets
import 'package:sign_language_app/More_Data/Letter_Images.dart'; // Custom letter images data
import 'package:sign_language_app/contscat/crud.dart'; // Custom CRUD operations
import 'package:sign_language_app/contscat/linksapp.dart'; // Custom API links
import 'package:sign_language_app/main.dart'; // Main application file
import 'package:sign_language_app/screens/LearnLetter.dart'; // Screen for learning letters

// Learn widget for teaching sign language letters
class Learn extends StatefulWidget {
  bool isLoading; // Whether the app is in a loading state

  // Constructor for Learn
  Learn({super.key, required this.isLoading});

  @override
  State<Learn> createState() => _LearnState();
}

// State class for Learn
class _LearnState extends State<Learn> {
  final API api = API(); // Instance of CRUD operations
  List<Map<String, dynamic>> LearnList =
      []; // List to store fetched learning data

  // Function to fetch learning history from the API
  fetchLetters() async {
    var response = await api.postRequest(
      linkGetLearn, // API endpoint for fetching learning history
      {'id': sharedPref.getString('id')}, // Request body with user ID
    );

    if (response == null) {
      // Handle null response
      return;
    }

    if (response['message'] == 'Not found') {
      // Handle no data found
      setState(() {
        LearnList = [];
      });
    } else {
      // Process response data
      setState(() {
        LearnList = List<Map<String, dynamic>>.from(
            response["data"]); // Map response data to list
      });
    }
  }

  // Function to reset learning progress for a specific letter
  reset_learn(String Letter) async {
    var response = await api.postRequest(
      linkResetLearn, // API endpoint for resetting learning progress
      {
        'id': sharedPref.getString('id'),
        'letter': Letter
      }, // Request body with user ID and letter
    );

    if (response == null) {
      // Handle null response
      _showSnackBar('فشل إعادة ضبط جميع الحروف'); // Show error message
      return;
    }

    if (response['message'] == 'Reset Success') {
      // Handle success
      _showSnackBar('نجح إعادة ضبط جميع الحروف'); // Show success message
      setState(() {
        LearnList.clear(); // Clear the list
        fetchLetters(); // Fetch updated data
      });
    } else {
      // Handle failure
      _showSnackBar('فشل إعادة ضبط جميع الحروف'); // Show error message
    }
  }

  // Function to clear learning progress for all letters
  resetAllLetters() async {
    var response = await api.postRequest(
      linkResetAllLearn, // API endpoint for resetting all learning progress
      {'id': sharedPref.getString('id')}, // Request body with user ID
    );

    if (response == null) {
      // Handle null response
      _showSnackBar('فشل مسح جميع الحروف'); // Show error message
      return;
    }

    if (response['message'] == 'All letters cleared successfully') {
      // Handle success
      _showSnackBar('نجح مسح جميع الحروف'); // Show success message
      setState(() {
        LearnList.clear(); // Clear the list
        fetchLetters(); // Fetch updated data
      });
    } else {
      // Handle failure
      _showSnackBar('فشل مسح جميع الحروف'); // Show error message
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

  @override
  void initState() {
    super.initState();
    fetchLetters(); // Fetch learning history when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black, // Set background color to black
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Container(
                height: 57,
                width: 360,
                decoration: BoxDecoration(
                  color: const Color(0XFF747474), // Container background color
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Navigate back
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 30),
                    const Text(
                      "تعليم لغة الأشارة العربية", // Title text
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Arabic-sans", // Arabic font
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () {
                          resetAllLetters(); // Clear all letters on tap
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            "images/reset_icon3.png", // Reset icon
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: LearnList.length, // Number of items in the grid
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns in the grid
                  crossAxisSpacing: 5, // Spacing between columns
                  mainAxisExtent: 180, // Height of each grid item
                  mainAxisSpacing: 2, // Spacing between rows
                  childAspectRatio: 7 / 8, // Aspect ratio of grid items
                ),
                itemBuilder: (context, index) {
                  return Card(
                    color: const Color(0XFF747474), // Card background color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                LearnList[index]["Name"], // Display letter name
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 60,
                                  fontFamily: "Arabic-sans", // Arabic font
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  LearnList[index][
                                      "Description"], // Display letter description
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontFamily: "Arabic-sans", // Arabic font
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: Image.asset(
                                    LearnList[index]["Done"] == "None"
                                        ? "images/white_image.jpeg" // Default image
                                        : LearnList[index]["Done"] == "True"
                                            ? "images/trueIcon.png" // Success icon
                                            : "images/falseIcon.png", // Failure icon
                                  ),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    reset_learn(LearnList[index][
                                        "Name"]); // Reset learning progress for this letter
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      "images/reset_icon3.png", // Reset icon
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    final result =
                                        await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => Learnletter(
                                          data: LearnList,
                                          isLoading: widget.isLoading,
                                          Image: Images[index], // Letter image
                                          Letter: LearnList[index]
                                              ["Name"], // Letter name
                                          Done: LearnList[index]
                                              ["Done"], // Learning status
                                        ),
                                      ),
                                    );

                                    if (result == true) {
                                      // If learning is successful
                                      setState(() {});
                                      LearnList.clear(); // Clear the list
                                      Future.delayed(
                                          Duration(milliseconds: 100), () {
                                        fetchLetters(); // Fetch updated data
                                      });
                                    }
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      "images/playIcon.png", // Play icon
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
