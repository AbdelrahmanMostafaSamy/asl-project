import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:winapp/CameraScreen.dart';
import 'package:winapp/RecordScreen.dart';
import 'package:winapp/linksapp.dart';
import 'package:winapp/login.dart';
import 'Home2.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultScreen extends StatefulWidget {
  final File? media; // Make media nullable
  final bool isVideo;
  final VideoPlayerController? videoPlayerController;

  ResultScreen({required this.media, required this.isVideo, Key? key})
      : videoPlayerController = isVideo && media != null ? VideoPlayerController.file(media) : null,
        super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String? prediction;
  bool _isSending = false;
  VideoPlayerController? _videoPlayerController; // Make nullable
  Future<void>? _initializeVideoPlayerFuture; // Make nullable

  @override
  void initState() {
    super.initState();
    if (widget.isVideo && widget.media != null) {
      _videoPlayerController = VideoPlayerController.file(widget.media!);
      _initializeVideoPlayerFuture = _videoPlayerController!.initialize().then((_) {
        _videoPlayerController!.setLooping(true);
        setState(() {}); // Update the UI after initialization
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose(); // Use null-aware operator
    super.dispose();
  }

  Future<void> _sendImage() async {
    setState(() {
      _isSending = true;
    });

    try {
      final bytes = await widget.media!.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(LinkModel), // Ensure correct endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'image': base64Image,
          'type': "Sign Language To Words",
          'id': globalID, // Ensure userId is provided
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          prediction = data['prediction'] ?? 'No prediction available';
        });
      } else {
        final errorData = jsonDecode(response.body);
        _showError("Error: ${errorData['error'] ?? 'Unknown error'}");
      }
    } catch (e) {
      _showError("Error sending image: $e");
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

 Future<void> uploadVideo() async {
    if (widget.media == null && widget.media == null) {
      
      return;
    }
    setState(() {
      _isSending = true;
    });
    try {
      var url = Uri.parse(LinkSendVideoModel); // API endpoint for video upload

      var request = http.MultipartRequest('POST', url)
        ..files.add(await http.MultipartFile.fromPath(
            'video',
            widget.media!.path ??
                widget.media!.path)); // Add video file to request

      var response = await request.send(); // Send request

      if (response.statusCode == 200) {
        // Check if request was successful
        var responseBody = await response.stream.bytesToString();
        var jsonData = jsonDecode(responseBody); // Decode response
        print("Prediction: ${jsonData['prediction']}");
        
        setState(() {
          prediction = jsonData['prediction'] ?? 'No prediction'; 
          _isSending = false;
        });
      } else {
        // Handle request failure
        print("Error: ${response.reasonPhrase}");
        setState(() {
          _isSending= false;
        });
      }
    } catch (e) {
      // Handle exceptions
      print(e);
      setState(() {
        _isSending = false;
      });
    }
  }
  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
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
                  child: widget.media != null
                      ? widget.isVideo
                          ? FutureBuilder(
                              future: _initializeVideoPlayerFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  return AspectRatio(
                                    aspectRatio: _videoPlayerController!.value.aspectRatio,
                                    child: VideoPlayer(_videoPlayerController!),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            )
                          : Image.file(
                              widget.media!,
                              fit: BoxFit.cover,
                            )
                      : const Text("No media available"), // Fallback for null media
                ),
              ),
              const SizedBox(height: 50),

              // Prediction Text or Placeholder
              Center(
                child: prediction != null
                    ? Text(
                      isArabic! ? "$prediction :التنبؤ" :
                  "Prediction: $prediction",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Segoe UI',
                  ),
                )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 30),

              // Buttons
              Padding(
                padding: const EdgeInsets.only(left: 250),
                child: Row(
                  children: [
                    // Send Button
                    Container(
                      alignment: Alignment.center,
                      height: 45,
                      width: 170,
                      decoration: const BoxDecoration(
                        color: Color(0xffBA33AB),
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      child: MaterialButton(
                        onPressed: _isSending ? null : widget.isVideo ? uploadVideo : _sendImage,
                        child: _isSending
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                              isArabic! ? 'إرسال' :
                          'Send',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Segoe UI',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),

                    // Back Button
                    Container(
                      alignment: Alignment.center,
                      height: 45,
                      width: 170,
                      decoration: const BoxDecoration(
                        color: Color(0xffBA33AB),
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      child: MaterialButton(
                        onPressed: () { 
                          if (widget.isVideo){
                           Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RecordScreen(),
                          ));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CameraScreen(),
                          ));
                        }
                        },
                        child: Text(
                          isArabic! ? 'العودة' :
                          'Back',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Segoe UI',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Video Controls
              // if (widget.isVideo && _videoPlayerController != null)
              //   Center(
              //     child: Row(
              //       children: [
              //         SizedBox(width: 418,),
              //         IconButton(
              //           icon: Icon(
              //             _videoPlayerController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
              //           ),
              //           onPressed: () {
              //             setState(() {
              //               if (_videoPlayerController!.value.isPlaying) {
              //                 _videoPlayerController!.pause();
              //               } else {
              //                 _videoPlayerController!.play();
              //               }
              //             });
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
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
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: () {
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