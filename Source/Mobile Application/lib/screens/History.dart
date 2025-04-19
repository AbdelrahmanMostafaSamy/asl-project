import 'package:flutter/material.dart'; // For Material Design widgets
import 'package:sign_language_app/More_Data/Language.dart'; // Custom language data
import 'package:sign_language_app/contscat/crud.dart'; // Custom CRUD operations
import 'package:sign_language_app/contscat/linksapp.dart'; // Custom API links
import 'package:sign_language_app/main.dart'; // Main application file
import 'package:sign_language_app/screens/HistoryData.dart'; // Screen to display history details

// History widget for displaying user history
class History extends StatefulWidget {
  bool isArabic; // Whether the app is in Arabic mode
  History({required this.isArabic}); // Constructor for History

  @override
  _HistoryState createState() => _HistoryState();
}

// State class for History
class _HistoryState extends State<History> {
  final API api = API(); // Instance of api operations
  List<Map<String, dynamic>> historyList = []; // List to store history data

  // Function to fetch history data from the API
  Future<void> fetchHistory() async {
    var response = await api.postRequest(linkHistory, {
      'id': sharedPref.getString('id') // Send user ID to fetch history
    });

    // Check if the widget is still mounted before calling setState
    if (!mounted) return;

    if (response == null) {
      // Handle null response
      setState(() {
        historyList = [];
      });
    } else if (response['message'] == 'Not found') {
      // Handle no history found
      setState(() {
        historyList = [];
      });
    } else {
      // Process response data
      setState(() {
        historyList = List<Map<String, dynamic>>.from(
            response['data']); // Map response data to list
      });
    }
  }

  // Function to delete a specific history item
  ClearHistory(int id) async {
    var response = await api.postRequest(LinkDeleteHistory, {
      'id': sharedPref.getString('id'), // User ID
      'history_id': id // History item ID
    });

    if (response!['message'] == 'History item deleted successfully') {
      // Handle success
      _showSnackBar(widget.isArabic
          ? 'نجح مسح السجل'
          : 'History Deleted'); // Show success message
      setState(() {
        historyList.clear(); // Clear the list
        fetchHistory(); // Fetch updated history
      });
    } else {
      // Handle failure
      _showSnackBar(widget.isArabic
          ? 'فشل مسح السجل'
          : 'Failed to delete history'); // Show error message
    }
  }

  // Function to delete all history items
  ClearAllHistory() async {
    var response = await api.postRequest(LinkDeleteAllHistory, {
      'id': sharedPref.getString('id') // User ID
    });

    if (response == null) {
      // Handle null response
      _showSnackBar(widget.isArabic
          ? 'فشل مسح السجل'
          : 'Failed to delete history'); // Show error message
      return;
    }

    if (response['message'] == 'All history cleared successfully') {
      // Handle success
      _showSnackBar(widget.isArabic
          ? 'نجح مسح السجل'
          : 'History Deleted'); // Show success message
      setState(() {
        historyList.clear(); // Clear the list
      });
    } else {
      // Handle failure
      _showSnackBar(widget.isArabic
          ? 'فشل مسح السجل'
          : 'Failed to delete history'); // Show error message
    }
  }

  // Function to show a snackbar with a message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(
          message,
          style: TextStyle(
              fontFamily: widget.isArabic
                  ? 'Arabic-sans'
                  : 'Racing-sans'), // Font based on language
        ),
        backgroundColor: const Color(0XFF747474), // Snackbar background color
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchHistory(); // Fetch history data when the widget is initialized
  }

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
                color: const Color(0XFF747474), // Container background color
                borderRadius: BorderRadius.circular(15), // Rounded corners
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Navigate back when pressed
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white, // Back icon color
                    ),
                  ),
                  const SizedBox(width: 93), // Spacing
                  Text(
                    widget.isArabic ? Arabic[26] : English[26], // Title text
                    style: TextStyle(
                      color: Colors.white, // Text color
                      fontFamily: widget.isArabic
                          ? "Arabic-sans"
                          : "Racing-sans", // Font based on language
                      fontSize: 23,
                    ),
                  ),
                  const SizedBox(width: 70), // Spacing
                  // Button to clear all history
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                      color: Colors.white, // Button background color
                    ),
                    child: InkWell(
                      onTap: ClearAllHistory, // Clear all history when pressed
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Icon(
                          Icons.delete,
                          size: 25,
                          color: Colors.grey[850], // Delete icon color
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Spacing
            // List of history items
            Expanded(
              child: historyList.isEmpty
                  ? Center(
                      child: Text(
                        widget.isArabic
                            ? Arabic[32]
                            : English[32], // Message when no history is found
                        style: TextStyle(
                          color: Colors.white70, // Text color
                          fontSize: 18,
                          fontFamily: widget.isArabic
                              ? "Arabic-sans"
                              : "Racing-sans", // Font based on language
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: historyList.length, // Number of history items
                      itemBuilder: (context, index) {
                        var historyItem =
                            historyList[index]; // Current history item
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors
                                  .grey[850], // Container background color
                              borderRadius:
                                  BorderRadius.circular(10), // Rounded corners
                            ),
                            child: Row(
                              children: [
                                Row(children: [
                                  Icon(
                                    Icons
                                        .video_library_sharp, // Icon for history item
                                    color: Colors.white,
                                    size: 30,
                                  )
                                ]),
                                SizedBox(
                                  width: 25, // Spacing
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        title: Text(
                                          historyItem["type"] ==
                                                  "Sign Language To Words"
                                              ? widget.isArabic
                                                  ? Arabic[12]
                                                  : English[
                                                      12] // Display type of history
                                              : historyItem["type"] ==
                                                      "Words To Sign Language"
                                                  ? widget.isArabic
                                                      ? Arabic[13]
                                                      : English[13]
                                                  : "",
                                          style: TextStyle(
                                            color: Colors.white, // Text color
                                            fontFamily: widget.isArabic
                                                ? "Arabic-sans"
                                                : "Racing-sans", // Font based on language
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          widget.isArabic
                                              ? "${historyItem["id"]} : رقم"
                                              : "ID : ${historyItem["id"]}", // Display history ID
                                          style: TextStyle(
                                            color: Colors.white, // Text color
                                            fontFamily: widget.isArabic
                                                ? "Arabic-sans"
                                                : "Racing-sans", // Font based on language
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        // Button to view history details
                                        IconButton(
                                          icon: const Icon(
                                            Icons.play_circle_fill,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Historydata(
                                                  isArabic: widget.isArabic,
                                                  type: historyItem[
                                                      "type"], // History type
                                                  result: historyItem[
                                                      "prediction"], // Prediction result
                                                  date:
                                                      "${historyItem["date"]}", // History date
                                                  image:
                                                      "${historyItem["image"]}", // History image
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        // Button to delete a specific history item
                                        Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                20), // Rounded corners
                                            color: Colors
                                                .white, // Button background color
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              int? historyId =
                                                  historyItem["id"] as int?;
                                              if (historyId != null) {
                                                ClearHistory(
                                                    historyId); // Delete history item
                                              } else {
                                                _showSnackBar(widget.isArabic
                                                    ? 'فشل مسح السجل'
                                                    : 'Failed to delete history'); // Show error message
                                              }
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Icon(
                                                Icons.delete,
                                                size: 25,
                                                color: Colors.grey[
                                                    850], // Delete icon color
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
