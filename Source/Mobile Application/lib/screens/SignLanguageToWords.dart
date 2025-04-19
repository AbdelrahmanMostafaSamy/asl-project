import 'dart:convert'; // For encoding/decoding data (e.g., JSON)
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart'; // For Material Design widgets
import 'package:image_picker/image_picker.dart';
import 'package:sign_language_app/More_Data/Language.dart'; // Custom language data
import 'package:sign_language_app/contscat/crud.dart'; // Custom api operations
import 'package:sign_language_app/contscat/linksapp.dart'; // Custom API links
import 'package:sign_language_app/main.dart'; // Main application file
import 'package:sign_language_app/widgets/ButtonMode.dart'; // Custom button widget
import 'package:sign_language_app/widgets/ContainerChooseOption.dart'; // Custom container widget
import 'package:sign_language_app/widgets/IconButtonApp.dart'; // Custom icon button widget
import 'package:url_launcher/url_launcher.dart'; // For launching URLs
import 'package:video_player/video_player.dart'; // For video playback
import 'dart:io'; // For file and directory operations
import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:socket_io_client/socket_io_client.dart' as IO;

// Signlanguagetowords widget for converting sign language videos to words
class Signlanguagetowords extends StatefulWidget {
  // final File? image; // Selected image file
  // final dynamic pickVideoFromGallery; // Function to pick video from gallery
  // final dynamic pickVideoFromCamera; // Function to pick video from camera
  // final dynamic togglePlayPause; // Function to toggle video play/pause
  // final bool showbottomSignLanguageToWords; // Whether to show the bottom sheet
  bool isArabic; // Whether the app is in Arabic mode
  bool isLoading; // Whether the app is in a loading state
  // final Function
  //     updateshowbottomSignLanguageToWords; // Function to update bottom sheet visibility
  // File? video; // Selected video file from gallery
  // File? cameraVideo; // Selected video file from camera
  // VideoPlayerController?
  //     cameraVideoPlayerController; // Controller for camera video
  // VideoPlayerController? videoPlayerController; // Controller for gallery video

  // Constructor for Signlanguagetowords
  Signlanguagetowords({
    super.key,
    required this.isLoading,
    // required this.updateshowbottomSignLanguageToWords,
    // this.image,
    // required this.togglePlayPause,
    required this.isArabic,
    // required this.pickVideoFromCamera,
    // required this.pickVideoFromGallery,
    // required this.showbottomSignLanguageToWords,
    // required this.cameraVideo,
    // required this.video,
    // required this.cameraVideoPlayerController,
    // required this.videoPlayerController,
  });

  @override
  State<Signlanguagetowords> createState() => _SignlanguagetowordsState();
}

// State class for Signlanguagetowords
class _SignlanguagetowordsState extends State<Signlanguagetowords> {
  API api = API(); // Instance of api operations

  File? image; // Selected image file
  bool result = true; // Whether to show the prediction result
  // Function to launch the WhatsApp group link
  Future<void> _launchNeedProblem() async {
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

  CameraController? _cameraController; // Make it nullable to avoid errors
  late IO.Socket socket;
  bool isStreaming = false;
  String? _processed;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _initSocket();
  }

  void _initSocket() {
    // Connect to the Socket.IO server
    socket = IO.io('http://192.168.1.4:5002', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    // Listen for connection events
    socket.onConnect((_) {
      print('Connected to Socket.IO server');
    });

    // Listen for the 'test' event from the server
    socket.on('prediction', (data) {
      print("Received processed from server");
      if (mounted) {
        setState(() {
          _processed = data;
          sharedPref.setString('prediction', data);
        });
      }
    });

    // Listen for disconnection events
    socket.onDisconnect((_) {
      _stopStreaming();
      socket.disconnect();
      print('Disconnected from Socket.IO server');
    });

    // Handle errors
    socket.onError((error) {
      print("Socket.IO error: $error");
    });
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();

      // Find the front camera
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        // orElse: () => null, // If no front camera is found, return null
      );

      if (frontCamera != null) {
        // Initialize the front camera
        final CameraController cameraController =
            CameraController(frontCamera, ResolutionPreset.low);
        await cameraController.initialize();

        if (!mounted)
          return; // Ensure widget is still mounted before updating state

        setState(() {
          _cameraController = cameraController;
        });
      } else {
        print('No front camera available');
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void _startStreaming() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      print("Camera not initialized yet");
      return;
    }
    isStreaming = true;
    _streamFrames();
  }

  bool _isCapturing = false; // Flag to ensure captures don't overlap

  void _streamFrames() async {
    while (isStreaming) {
      if (_cameraController == null ||
          !_cameraController!.value.isInitialized) {
        print("Camera stopped streaming due to unavailability");
        return;
      }

      if (_isCapturing) {
        // If still capturing, skip this frame
        await Future.delayed(
            Duration(milliseconds: 20)); // Wait before checking again
        continue;
      }

      _isCapturing = true; // Mark the start of capturing

      try {
        final XFile frame = await _cameraController!.takePicture();
        Uint8List imgBytes = await frame.readAsBytes();
        String base64String = base64Encode(imgBytes);

        // Send the base64-encoded frame to the server using the 'video_stream' event
        socket.emit('video_stream', base64String);
      } catch (e) {
        print('Error capturing frame: $e');
      } finally {
        _isCapturing = false; // Reset the flag after capture
      }

      // Ensure a proper delay between captures to manage FPS
      await Future.delayed(
          Duration(milliseconds: 100)); // Adjust FPS rate as needed
    }
  }

  void _stopStreaming() {
    isStreaming = false;
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    socket.disconnect();
    super.dispose();
  }

  // Function to show a snackbar with a message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 1),
        content: Text(
          message,
          style: TextStyle(
              fontFamily: widget.isArabic ? "Arabic-sans" : 'Racing-sans'),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 100),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                  height: 390,
                  width: 300,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 5),
                  ),
                  padding: EdgeInsets.all(4.0),
                  child: widget.isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                          color: Color(0XFFBA33AB),
                        ))
                      : _cameraController != null &&
                              _cameraController!.value.isInitialized
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: 300, // Same width as the container
                                  height: 390, // Same height as the container
                                  child: _cameraController != null &&
                                          _cameraController!.value.isInitialized
                                      ? CameraPreview(_cameraController!)
                                      : Container(
                                          color: Colors
                                              .grey, // A fallback if the camera isn't initialized
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        ),
                                ),
                              ))
                          : Container(
                              height: 400,
                              width: 280,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: ClipRRect(
                                child: Image.asset("images/ASLP Logo4.png"),
                              ))),
            ],
          ),
          SizedBox(height: 20),
          Container(
            width: 275,
            height: 180,
            decoration: BoxDecoration(
              color: Color(0XFFD9D9D9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black, width: 4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: result
                  ? Text(
                      sharedPref.getString("prediction") == ""
                          ? "${widget.isArabic ? "لا يوجد نواتج" : "No Result"}"
                          : sharedPref.getString("prediction") ?? "",
                      style: TextStyle(
                        fontFamily: "Arabic-sans",
                        fontSize: 20,
                      ),
                    )
                  : Text(""),
            ),
          ),
          SizedBox(height: 30),
          isStreaming
              ? Container()
              : Center(
                  child: Buttonmode(
                      font: widget.isArabic ? "Arabic-sans" : "Racing-sans",
                      text: widget.isArabic ? Arabic[15] : English[15],
                      width: 130,
                      height: 48,
                      color: Colors.white,
                      icon: Icons.stream,
                      backgroundcolor: Color(0XFFBA33AB),
                      onPressed: () {
                        _startStreaming();
                        result = true;
                      }),
                ),
          // SizedBox(width: 40),
          isStreaming == false
              ? Container()
              : Center(
                  child: Buttonmode(
                    font: widget.isArabic ? "Arabic-sans" : "Racing-sans",
                    width: 130,
                    height: 48,
                    text: widget.isArabic ? Arabic[16] : English[16],
                    color: Colors.black,
                    icon: Icons.stop,
                    backgroundcolor: Color(0XFF9F9D9D),
                    onPressed: () {
                      setState(() {
                        result = false; // Toggle result visibility
                        _stopStreaming();
                      });
                    },
                  ),
                ),

          Padding(
            padding: EdgeInsets.all(10),
            child: TextButton(
              onPressed: _launchNeedProblem, // Launch WhatsApp group link
              child: Text(
                widget.isArabic ? Arabic[17] : English[17],
                style: TextStyle(
                  fontFamily: widget.isArabic ? "Arabic-sans" : "Racing-sans",
                  color: Color(0xFFBA33AB),
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xFFBA33AB),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
