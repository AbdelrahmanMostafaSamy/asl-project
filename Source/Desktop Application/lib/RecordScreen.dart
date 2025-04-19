import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_win/video_player_win.dart';
import 'package:video_player_win/video_player_win_platform_interface.dart';
import 'Home2.dart';
import 'Result.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  File? _selectedVideo;
  final ImagePicker _imagePicker = ImagePicker();
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;
  VideoPlayerController? _videoController;
  bool _isPlaying = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) throw Exception('No cameras available');

      _controller = CameraController(
        _cameras[0], // Use the first available camera
        ResolutionPreset.high,
        fps: 30
      );

      await _controller.initialize();
      setState(() => _isCameraInitialized = true);
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _captureVideo() async {
    if (_isCameraInitialized && !_isRecording) {
      try {
        await _controller.startVideoRecording();
        setState(() => _isRecording = true);
      } catch (e) {
        print("Error starting video recording: $e");
      }
    }
  }

  Future<void> _stopRecording() async {
    if (_isCameraInitialized && _isRecording) {
      try {
        XFile videoFile = await _controller.stopVideoRecording();
        setState(() {
          _selectedVideo = File(videoFile.path);
          _initializeVideoController(_selectedVideo!);
          _isRecording = false;
        });
      } catch (e) {
        print("Error stopping video recording: $e");
      }
    }
  }

  Future<void> _pickVideo() async {
    final XFile? videoFile = await _imagePicker.pickVideo(source: ImageSource.gallery);
    if (videoFile != null) {
      setState(() {
        _selectedVideo = File(videoFile.path);
        _initializeVideoController(_selectedVideo!);
      });
    }
  }

  Future<void> _initializeVideoController(File video) async {
    _videoController = VideoPlayerController.file(video);
    await _videoController!.initialize();
    _videoController!.play();
    _videoController!.setLooping(true);
    setState(() {});
  }

  void _togglePlayPause() {
    if (_videoController != null) {
      setState(() {
        if (_videoController!.value.isPlaying) {
          _videoController!.pause();
          _isPlaying = false;
        } else {
          _videoController!.play();
          _isPlaying = true;
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _videoController?.dispose();
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
            child: Container(
              height: 290,
              width: 850,
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
          ListView(
            children: [
              const SizedBox(height: 40),
              SizedBox(
                height: 320,
                child: Center(
                  child: _selectedVideo != null
                      ? _videoController != null && _videoController!.value.isInitialized
                          ? Column(
                              children: [ 
                                SizedBox(
                                  width: 565, height: 320,
                                  child: VideoPlayer(_videoController!),
                                ),
                              ],
                            )
                          : const Text("Loading video...")
                      : _isCameraInitialized
                          ? SizedBox(width: 565, height: 500, child: _controller.buildPreview())
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
                        onPressed: _selectedVideo != null
                            ? () {
                              dispose();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ResultScreen(media: _selectedVideo!, isVideo: true),
                                  ),
                                );
                              }
                            : () async {
                                if (_isRecording) {
                                  await _stopRecording();
                                } else {
                                  await _captureVideo();
                                }
                              },
                        child: Text(
                          _selectedVideo == null? _isRecording
                              ? isArabic! ? 'إيقاف التسجيل' : 'Stop Recording'
                              : isArabic! ? 'التقاط' : 'Capture' : isArabic! ? 'التالى' : "Next",
                          style: const TextStyle(color: Colors.white, fontSize: 16),
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
                        onPressed: _pickVideo,
                        child: Text(
                          isArabic! ? 'اختيار من الملفات' : 'Select from files',
                          style: const TextStyle(color: Colors.white, fontSize: 16),
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
                  BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 6, offset: Offset(0, 4)),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_left_rounded, color: Colors.white),
                onPressed: () {
                  dispose();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => home()));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
