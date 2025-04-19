import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:camera/camera.dart';
import 'Home2.dart';
import 'Result.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class Camerascreen extends StatelessWidget {
  const Camerascreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraScreen(),
    );
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        throw Exception('No cameras available');
      }
      _controller = CameraController(
        _cameras[0], // Select the first available camera
        ResolutionPreset.high,
      );
      await _controller.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _captureImage() async {
    if (_isCameraInitialized) {
      try {
        final XFile? image = await _controller.takePicture();
        if (image != null) {
          // Read the new image file
          File originalFile = File(image.path);
          Uint8List imageBytes = await originalFile.readAsBytes();

          // Decode the image
          img.Image? decodedImage = img.decodeImage(imageBytes);
          if (decodedImage != null) {
            // Flip the image horizontally
            img.Image flippedImage = img.flipHorizontal(decodedImage);

            // Get the directory to save the modified image
            final directory = await getTemporaryDirectory();
            String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
            String flippedImagePath = '${directory.path}/flipped_$timestamp.jpg';

            // Save the flipped image
            File flippedFile = File(flippedImagePath);
            await flippedFile.writeAsBytes(img.encodeJpg(flippedImage));

            // Update UI
            setState(() {
              _selectedImage = flippedFile;
            });
          }
        }
      } catch (e) {
        print("Error capturing image: $e");
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? image =
    await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('Assets/Images/background.jpg'),
                fit: BoxFit.cover,
                opacity: 0.1,
              ),
            ),
          ),
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
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!)
                      : _isCameraInitialized
                      ? SizedBox(width: 565,height: 500,child: _controller.buildPreview(),)
                      : const CircularProgressIndicator(),
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(left: 250),
                child: Row(
                  children: [
                    Container(
                      height: 45,
                      width: 170,
                      decoration: const BoxDecoration(
                        color: Color(0xffBA33AB),
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      child: MaterialButton(
                        onPressed: _selectedImage != null
                            ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ResultScreen(media: _selectedImage!,isVideo: false,),
                            ),
                          );
                          dispose();
                        }
                            : _captureImage,
                        child: Text(
                            _selectedImage != null ? isArabic! ? 'متابعة' : 'Proceed' : isArabic! ? 'التقاط' : 'Capture',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Segoe UI',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    Container(
                      height: 45,
                      width: 170,
                      decoration: const BoxDecoration(
                        color: Color(0xffBA33AB),
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      child: MaterialButton(
                        onPressed: _pickImage,
                        child: Text(
                          isArabic! ? 'اختيار من الملفات' :
                          'Select From Files',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Racing ',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
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
                  Icons.arrow_left_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  dispose();
                  _selectedImage = null;

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => home(),
                  ));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
