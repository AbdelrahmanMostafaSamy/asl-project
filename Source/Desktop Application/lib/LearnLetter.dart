import 'package:flutter/material.dart';
import 'package:winapp/login.dart';
import 'home2.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'RnG.dart';
import 'linksapp.dart';
import 'CheckTrueOrFalse.dart';
import 'IconButtonApp.dart';
import 'ButtonMode.dart';
import 'ShowLetter.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:camera/camera.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class Learnletter extends StatefulWidget {
  String Image;
  String Done;
  List<Map<String, dynamic>> data;
  String Letter;
  bool isLoading;

  
  Learnletter(
      {super.key,
      required this.Done,
      required this.Image,
      required this.Letter,
      required this.isLoading,
      required this.data});

  @override
  State<Learnletter> createState() => _LearnletterState();
}

class _LearnletterState extends State<Learnletter> {
  String check1 = "None";
  String check2 = "None";
  String check3 = "None";
  String check4 = "None";
  String check5 = "None";
  bool button = true;
  Crud crud = Crud();

  @override
  void initState() {
    super.initState();
    if (widget.Done == 'False') {
      check1 = 'False';
      check2 = 'False';
      check3 = 'False';
      check4 = 'False';
      check5 = 'False';
      button = false;
    } else if (widget.Done == 'True') {
      check1 = 'True';
      check2 = 'True';
      check3 = 'True';
      check4 = 'True';
      check5 = 'True';
      button = false;
    }
    _initializeCamera();
  }

  checkLearn(String Letter, String Done) async {
    var response = await crud.postRequest(linkLearn,
        {'letter': Letter, 'id': globalID.toString(), "done": Done});
  }

  check() async {
    if (_cameraImage == null) {
      _showSnackBar('أدخل صورة أولا');
      return;
    }
    
    try {
      Uint8List bytes = await _cameraImage!.readAsBytes();
      setState(() {
        widget.isLoading = true;
      });

      var response = await crud.postRequest(LinkModel, {
        'image': base64Encode(bytes),
        'type': 'learn',
        'id': globalID.toString()
      });
      setState(() {
        widget.isLoading = false;
      });

      if (response == null) {
        // _showSnackBar('No response from server');
        setState(() {
          _cameraImage = null;
          count += 1;
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

        // Add a delay
        // Future.delayed(Duration(seconds: 2), () {
        setState(() {
          if (count == 5) {
            button = false;
            if ((check1 == 'True' &&
                    check2 == 'True' &&
                    check3 == 'True' &&
                    check4 == 'False' &&
                    check5 == 'False') ||
                (check1 == 'True' &&
                    check2 == 'True' &&
                    check4 == 'True' &&
                    check3 == 'False' &&
                    check5 == 'False') ||
                (check1 == 'True' &&
                    check2 == 'True' &&
                    check5 == 'True' &&
                    check3 == 'False' &&
                    check4 == 'False') ||
                (check1 == 'True' &&
                    check3 == 'True' &&
                    check4 == 'True' &&
                    check2 == 'False' &&
                    check5 == 'False') ||
                (check1 == 'True' &&
                    check3 == 'True' &&
                    check5 == 'True' &&
                    check2 == 'False' &&
                    check4 == 'False') ||
                (check1 == 'True' &&
                    check4 == 'True' &&
                    check5 == 'True' &&
                    check2 == 'False' &&
                    check3 == 'False') ||
                (check2 == 'True' &&
                    check3 == 'True' &&
                    check4 == 'True' &&
                    check1 == 'False' &&
                    check5 == 'False') ||
                (check2 == 'True' &&
                    check3 == 'True' &&
                    check5 == 'True' &&
                    check1 == 'False' &&
                    check4 == 'False') ||
                (check2 == 'True' &&
                    check4 == 'True' &&
                    check5 == 'True' &&
                    check1 == 'False' &&
                    check3 == 'False') ||
                (check3 == 'True' &&
                    check4 == 'True' &&
                    check5 == 'True' &&
                    check1 == 'False' &&
                    check2 == 'False') ||
                (check1 == 'True' &&
                    check2 == 'True' &&
                    check3 == 'True' &&
                    check4 == 'True' &&
                    check5 == 'False') ||
                (check1 == 'True' &&
                    check2 == 'True' &&
                    check3 == 'True' &&
                    check5 == 'True' &&
                    check4 == 'False') ||
                (check1 == 'True' &&
                    check2 == 'True' &&
                    check4 == 'True' &&
                    check5 == 'True' &&
                    check3 == 'False') ||
                (check1 == 'True' &&
                    check3 == 'True' &&
                    check4 == 'True' &&
                    check5 == 'True' &&
                    check2 == 'False') ||
                (check2 == 'True' &&
                    check3 == 'True' &&
                    check4 == 'True' &&
                    check5 == 'True' &&
                    check1 == 'False') ||
                (check1 == 'True' &&
                    check2 == 'True' &&
                    check3 == 'True' &&
                    check4 == 'True' &&
                    check5 == 'True')) {
              checkLearn(widget.Letter, "True");
              // Navigator.of(context).pop(true); // إرجاع true عند نجاح التعلم
            } else {
              checkLearn(widget.Letter, "False");
              // Navigator.of(context).pop(true); // إرجاع true عند نجاح التعلم
            }
          }
        });
        // });
        return;
      }

      else if (response['prediction'] != null) {
        if (response['prediction'] == widget.Letter) {
          _showSnackBar('${response['prediction']} : الناتج  ');
          setState(() {
            _cameraImage = null;
            count += 1;
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
          setState(() {
            _cameraImage = null;
            count += 1;
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
            button = false;
            if ((check1 == 'True' &&
                    check2 == 'True' &&
                    check3 == 'True' &&
                    check4 == 'False' &&
                    check5 == 'False') ||
                (check1 == 'True' &&
                    check2 == 'True' &&
                    check4 == 'True' &&
                    check3 == 'False' &&
                    check5 == 'False') ||
                (check1 == 'True' &&
                    check2 == 'True' &&
                    check5 == 'True' &&
                    check3 == 'False' &&
                    check4 == 'False') ||
                (check1 == 'True' &&
                    check3 == 'True' &&
                    check4 == 'True' &&
                    check2 == 'False' &&
                    check5 == 'False') ||
                (check1 == 'True' &&
                    check3 == 'True' &&
                    check5 == 'True' &&
                    check2 == 'False' &&
                    check4 == 'False') ||
                (check1 == 'True' &&
                    check4 == 'True' &&
                    check5 == 'True' &&
                    check2 == 'False' &&
                    check3 == 'False') ||
                (check2 == 'True' &&
                    check3 == 'True' &&
                    check4 == 'True' &&
                    check1 == 'False' &&
                    check5 == 'False') ||
                (check2 == 'True' &&
                    check3 == 'True' &&
                    check5 == 'True' &&
                    check1 == 'False' &&
                    check4 == 'False') ||
                (check2 == 'True' &&
                    check4 == 'True' &&
                    check5 == 'True' &&
                    check1 == 'False' &&
                    check3 == 'False') ||
                (check3 == 'True' &&
                    check4 == 'True' &&
                    check5 == 'True' &&
                    check1 == 'False' &&
                    check2 == 'False') ||
                (check1 == 'True' &&
                    check2 == 'True' &&
                    check3 == 'True' &&
                    check4 == 'True' &&
                    check5 == 'False') ||
                (check1 == 'True' &&
                    check2 == 'True' &&
                    check3 == 'True' &&
                    check5 == 'True' &&
                    check4 == 'False') ||
                (check1 == 'True' &&
                    check2 == 'True' &&
                    check4 == 'True' &&
                    check5 == 'True' &&
                    check3 == 'False') ||
                (check1 == 'True' &&
                    check3 == 'True' &&
                    check4 == 'True' &&
                    check5 == 'True' &&
                    check2 == 'False') ||
                (check2 == 'True' &&
                    check3 == 'True' &&
                    check4 == 'True' &&
                    check5 == 'True' &&
                    check1 == 'False') ||
                (check1 == 'True' &&
                    check2 == 'True' &&
                    check3 == 'True' &&
                    check4 == 'True' &&
                    check5 == 'True')) {
              checkLearn(widget.Letter, "True");
              // Navigator.of(context).pop(true); // إرجاع true عند نجاح التعلم
            } else {
              checkLearn(widget.Letter, "False");
              // Navigator.of(context).pop(true); // إرجاع true عند نجاح التعلم
            }
          }
          // });
        });
      } else {
        _showSnackBar('Unexpected response');
      }
    } catch (e) {
      setState(() {
        widget.isLoading = false;
      });
      _showSnackBar('An error occurred: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 1),
        content: Text(
          message,
          style: TextStyle(fontFamily: 'Arabic-sans'),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }

  int count = 0;

  final ImagePicker pickerr = ImagePicker();
  File? _cameraImage;

  _pickImageFromGallery() async {
    final XFile? pickedFile = await pickerr.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _cameraImage = File(pickedFile.path);
      });
    }
  }
  
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;

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
              _cameraImage = flippedFile;
              _selectedImage = null;
            });
          }
        }
      } catch (e) {
        print("Error capturing image: $e");
      }
    }
  }
  
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            body: SingleChildScrollView(
              child: Column(children: [
                Center(
                  child: Container(
                    height: 57,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: const Color(0XFF747474)),
                    child: Row(
                      children: [
                        const SizedBox(width: 30),
                        IconButton(
                          onPressed: () {
                            _controller.dispose();
                            _selectedImage = null;
                            Navigator.of(context)
                                .pop(true); // إرجاع true عند نجاح التعلم
                            count = 0;
                            _cameraImage = null;
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 280),
                        Center(
                          child: Text(
                            "تعلم حرف ${widget.Letter}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Arabic-sans",
                              fontSize: 27,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  
                  const SizedBox(width: 100),
                Container(
                    height: 400,
                    width: 665,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0XFF747474), width: 7),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: _cameraImage == null
                        ? SizedBox(
                height: 320,
                child: Center(
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!)
                      : _isCameraInitialized
                      ? ClipRRect(child: _controller.buildPreview(),)
                      : const CircularProgressIndicator(),
                ),
              )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Image.file(
                              _cameraImage!,
                              fit: BoxFit.cover,
                            ),
                          )),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Iconbuttonapp(
                        color: const Color(0XFF747474),
                        colorIcon: Colors.white,
                        icon: Icons.image_search,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Showletter(
                                image: widget.Image, Letter: widget.Letter),
                          ));
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    Iconbuttonapp(
                        color: const Color(0XFF747474),
                        colorIcon: Colors.white,
                        icon: Icons.camera_outlined,
                        onPressed: () {
                          if (widget.Done == 'False' ||
                              widget.Done == 'True' ||
                              button == false) {
                            Container();
                          } else {
                            _captureImage();
                          }
                        }),
                  ],
                ),
                ],),
                const SizedBox(
                  height: 20,
                ),
                Row(children: [
                  const SizedBox(
                  width: 285,
                ),
                Container(
                  height: 70,
                  width: 270,
                  decoration: BoxDecoration(
                      color: const Color(0XFF747474),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Checktrueorfalse(
                          check: check1,
                          count: count,
                        ),
                        Checktrueorfalse(check: check2, count: count),
                        Checktrueorfalse(check: check3, count: count),
                        Checktrueorfalse(check: check4, count: count),
                        Checktrueorfalse(check: check5, count: count),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                widget.isLoading? const CircularProgressIndicator():
                Visibility(
                  visible: button,
                  child: Buttonmode(
                    font: "Arabic-sans",
                    text: isArabic! ? "التحقق" : "Check",
                    color: Colors.white,
                    icon: Icons.check_circle,
                    backgroundcolor: const Color(0XFF747474),
                    onPressed: () => check(),
                    height: 50,
                    width: 140,
                  ),
                ),
              
                ],
                  
                )
                ]),
            )));
  }
}

class LearnLetter extends StatelessWidget {
  final File? image;

  const LearnLetter({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic! ? "تعلم الحروف" : "Learn Letters"),
      ),
      body: Center(
        child: image == null
            ? Text(isArabic! ? "لم يتم التقاط صورة" : "No image captured")
            : Image.file(image!),
      ),
    );
  }
}