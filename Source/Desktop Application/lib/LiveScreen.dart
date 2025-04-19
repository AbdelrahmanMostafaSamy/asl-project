import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';
import 'dart:typed_data';
import 'Home2.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:camera/camera.dart';
import 'linksapp.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  _LiveScreenState createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  String? _prediction;
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false; // Make it nullable to avoid errors
  late IO.Socket socket;
  bool isStreaming = false;
  String? _processed;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initSocket();
  }

  void _initSocket() {
    // Connect to the Socket.IO server
    socket = IO.io("http://192.168.1.4:5001", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    // Listen for connection events
    socket.onConnect((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connected to Socket.IO server'),
          duration: Duration(seconds: 2),
        ),
      );
    });

    // Listen for the 'test' event from the server
    socket.on('prediction', (data) {
      print("Received data from server");
      setState(() {
        _processed = data;
        _prediction = _processed.toString();
      });
    });

    // Listen for disconnection events
    socket.onDisconnect((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Disconnected from Socket.IO server'),
          duration: Duration(seconds: 2),
        ),
      );
    });

    // Handle errors
    socket.onError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
        title: const Text('Connection Error'),
        content: Text('Failed to connect to server: $error. Would you like to Re-connect?'),
        actions: [
          TextButton(
            onPressed: () {
          Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
          Navigator.of(context).pop();
          socket.connect(); // Retry connection
            },
            child: const Text('Retry'),
          ),
        ],
          );
        },
      );
    });
  
    socket.connect();
    // Handle connection errors
    socket.onConnectError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
        title: const Text('Connection Error'),
        content: Text('Failed to connect to server: $error. Would you like to Re-connect?'),
        actions: [
          TextButton(
            onPressed: () {
          Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
          Navigator.of(context).pop();
          socket.connect(); // Retry connection
            },
            child: const Text('Retry'),
          ),
        ],
          );
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection error: $error'),
          duration: Duration(seconds: 2),
        ),
      );

    });
  }

 Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        throw Exception('No cameras available');
      }
      _cameraController = CameraController(
        _cameras[0], // Select the first available camera
        ResolutionPreset.high,
        fps: 30
      );
      await _cameraController.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

 

  void _streamFrames() async {
    while (isStreaming) {
      if (_cameraController == null || !_cameraController!.value.isInitialized) {
        print("Camera stopped streaming due to unavailability");
        return;
      }

      final XFile frame = await _cameraController!.takePicture();
      Uint8List imgBytes = await frame.readAsBytes();
      String base64String = base64Encode(imgBytes);

      // Send the base64-encoded frame to the server using the 'video_stream' event
      socket.emit('video_stream', base64String);

      await Future.delayed(Duration(milliseconds: 100)); // Adjust FPS
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

  void _stopStreaming() {
    isStreaming = false;
  }
  
  @override
  void dispose() {
    super.dispose();
    _stopStreaming();
    _prediction = null;
    _cameraController.dispose();
    socket.disconnect();
    socket.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Background Decoration
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('Assets/Images/background.jpg'),
                fit: BoxFit.cover,
                opacity: 0.1,
              ),
            ),
          ),

          // Top Header
          Positioned(
            top: 0,
            child: SizedBox(
              height: 290,
              width: 850,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: const Color(0xffBA33AB),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
          ),

          ListView(
            children: [
              const SizedBox(height: 40),
              SizedBox(
                height: 320,
                child: Center(
                  child: _isCameraInitialized
                      ? SizedBox(width: 565,height: 500,child: _cameraController.buildPreview(),)
                      : const CircularProgressIndicator(),
                ),
              ),
              // Prediction Text or Placeholder
              Center(
                child: _prediction != null
                    ? Text(
                        isArabic! ? "$_prediction :التنبؤ" : "Prediction: $_prediction",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Segoe UI',
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _startStreaming,
                  style: ElevatedButton.styleFrom(
                    iconColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  child: Text( isStreaming ? "Streaming frames...": "Start Streaming"
                  ),
                ),
              ),
              
            ],
          ),


          // Back Icon Button
          Positioned(
            top: 15.0,
            left: 16.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black87,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  _cameraController.dispose();
                  dispose();
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
