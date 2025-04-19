import 'package:flutter/material.dart';
import 'package:sign_language_app/More_Data/Language.dart'; // Import language data
import 'package:sign_language_app/contscat/crud.dart'; // Import CRUD operations
import 'package:sign_language_app/main.dart'; // Main application file
import 'package:sign_language_app/screens/ChooseLetterToLearn.dart'; // Screen for learning letters
import 'package:sign_language_app/screens/History.dart'; // Screen for user history
import 'package:sign_language_app/screens/LoginScreen.dart'; // Login screen
import 'package:sign_language_app/screens/PageChooseType.dart'; // Screen to choose functionality
import 'package:sign_language_app/screens/SettingsPage.dart'; // Settings screen
import 'package:sign_language_app/screens/SignLanguageToWord2.dart';
import 'package:sign_language_app/screens/SignLanguageToWords.dart'; // Screen to convert sign language to words
import 'package:sign_language_app/screens/SignUpScreen.dart'; // Sign-up screen
import 'package:image_picker/image_picker.dart'; // Package for picking images/videos
import 'package:sign_language_app/screens/WordsToSignLanguage.dart'; // Screen to convert words to sign language
import 'package:sign_language_app/widgets/ButtonSignupOrLogin.dart'; // Custom button widget
import 'package:sign_language_app/widgets/ContainerChooseLearn.dart'; // Custom container widget
import 'package:sign_language_app/widgets/SettingsButton.dart'; // Custom settings button widget
import 'package:url_launcher/url_launcher.dart'; // Package for launching URLs
import 'dart:io'; // For file handling
import 'package:video_player/video_player.dart'; // Package for video playback
import 'package:camera/camera.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SignOrLogScreen extends StatefulWidget {
  String name;
  SignOrLogScreen(
      {super.key,
      required this.name}); // Constructor with a required name parameter

  @override
  State<SignOrLogScreen> createState() =>
      _SignOrLogScreenState(); // Create state for this widget
}

class _SignOrLogScreenState extends State<SignOrLogScreen> {
  // Controllers for text fields
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _textconvertController = TextEditingController();

  // Variables for UI dimensions
  double heightBackGround = 427;
  late double widthBackGround;
  double heightBar = 57;
  double widthBar = 57;
  double heightContenarSignuporLogin = 250;
  double logo_drawer_height = 0;
  double logo_drawer_width = 0;

  // Boolean variables to control UI visibility
  bool _Name = false;
  bool _drawer = false;
  bool _logo_show = true;
  bool _pagechooseSignuporLogin = false;
  bool _signup = false;
  bool _firstpage = true;
  bool _login = false;
  bool _Bar = false;
  bool signlanguagetowords = false;
  bool signlanguagetowords1 = false;
  bool signlanguagetowords2 = false;

  bool wordstosignlanguage = false;
  bool learnletter = false;
  bool isLoading = false;

  API api = API(); // Instance of CRUD operations
  bool _change_language = true; // Toggle for language change
  bool showPageChoose = false; // Show/hide page choose screen
  String iconn = "images/arrow_icon.png"; // Icon path
  String logo = "images/ASLP Logo3.png"; // Logo path
  bool showbottomSignLanguageToWords =
      false; // Show/hide bottom sheet for sign language to words
  bool showbottomSignup = false; // Show/hide bottom sheet for sign-up
  bool showbottomLetters = false; // Show/hide bottom sheet for letters

  // Variables for image and video handling
  File? _image;
  File? _video;
  File? _cameraVideo;
  final ImagePicker picker = ImagePicker(); // Image picker instance
  VideoPlayerController?
      _videoPlayerController; // Controller for video playback
  VideoPlayerController?
      _cameraVideoPlayerController; // Controller for camera video playback

  // Reset icon and logo
  void reset_icon_logo() {
    setState(() {
      iconn = "images/arrow_icon - Copy.png";
      logo = "images/ASLP Logo3.png";
      _Name = false;
    });
  }

  // Update page type (sign language to words, words to sign language, learn letters)
  void updatePageChooseType(bool signlanguagetowords, bool wordstosignlanguage,
      bool learnletter, bool signlanguagetowords1, bool signlanguagetowords2) {
    setState(() {
      this.signlanguagetowords = signlanguagetowords;
      this.signlanguagetowords1 = signlanguagetowords1;
      this.signlanguagetowords2 = signlanguagetowords2;

      this.wordstosignlanguage = wordstosignlanguage;
      this.learnletter = learnletter;
    });
  }

  // Close the bottom sheet for letters
  void updateCloseShowBottomLetters() {
    setState(() {
      showbottomLetters = false;
    });
  }

  // Toggle the bottom sheet for letters
  void updateShowBottomLetters() {
    setState(() {
      showbottomLetters = !showbottomLetters;
    });
  }

  // Update the visibility of the page choose screen
  void updateShowPage(bool showpage) {
    setState(() {
      showPageChoose = showpage;
    });
  }

  // Pick an image from the gallery
  _pickImageFromGallery() async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Pick an image from the camera
  _pickImageFromCamera() async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Handle login success
  void _onLoginSuccess() {
    setState(() {
      _login = false;
      _signup = false;
      showPageChoose = true;
      heightBackGround = 320;
      _change_language = false;
      iconn = "images/ASLP Logo3.png";
      logo = "images/menu_icon2.jpeg";
      _image = null;
      _Name = true;
    });
  }

  // Toggle play/pause for video
  void _togglePlayPause(VideoPlayerController? controller) {
    if (controller != null) {
      setState(() {
        controller.value.isPlaying ? controller.pause() : controller.play();
      });
    }
  }

  // Pause video
  void _togglePause(VideoPlayerController? controller) {
    if (controller != null) {
      setState(() {
        controller.pause();
      });
    }
  }

  // Handle sign-up success
  void _onSignupSuccess() {
    setState(() {
      _login = true;
      _signup = false;
      _change_language = false;
    });
  }

  // Handle logo press
  void logo_onPresed() {
    setState(() {
      if (showPageChoose && !_signup) {
        if (iconn == "images/arrow_icon - Copy.png") {
          showPageChoose = true;
          learnletter = false;
          _change_language = false;
          signlanguagetowords = false;
          wordstosignlanguage = false;
          result = false;
          _video = null;
          _cameraVideoPlayerController = null;
          _videoPlayerController = null;

          if (showbottomSignup) {
            if (Navigator.canPop(context)) Navigator.pop(context);
          } else {
            updateshowbottomSignup();
            updateCloseShowBottomLetters();
          }
          print("Hamza");
          _Name = true;
          logo = "images/menu_icon2.jpeg";
          iconn = "images/ASLP Logo3.png";
        } else {
          if (showbottomSignup) {
            if (Navigator.canPop(context)) Navigator.pop(context);
          } else {
            updateshowbottomSignup();
          }

          _Name = false;
        }
      } else {
        if (iconn == "images/arrow_icon.png") {
          widthBar = 57;
          result = false;
          heightBackGround = 427;
          _nameController.text = "";
          _emailController.text = "";
          _passwordController.text = "";
          _image = null;
          _change_language = true;
          _video = null;
          showbottomLetters = false;

          if (showbottomSignup) {
            if (Navigator.canPop(context)) Navigator.pop(context);
          } else {
            updateshowbottomSignup();
          }

          _firstpage = true;
          _signup = false;
          _login = false;
          _Bar = false;

          if (showbottomSignLanguageToWords) {
            if (Navigator.canPop(context)) Navigator.pop(context);
          } else {
            updateshowbottomSignLanguageToWords();
          }

          showPageChoose = false;
          _Name = false;
        } else if (iconn == "images/ASLP Logo3.png") {
          if (showbottomSignup) {
            if (Navigator.canPop(context)) Navigator.pop(context);
          } else {
            updateshowbottomSignup();
          }
          _Name = false;
          result = false;
          _textconvertController.text = "";
        } else if (logo == "images/ASLP Logo3.png") {
          if (showbottomSignup) {
            if (Navigator.canPop(context)) Navigator.pop(context);
          } else {
            updateshowbottomSignup();
          }
          updateShowPage(true);
          _textconvertController.text = "";
          logo = "images/menu_icon2.jpeg";
          iconn = "images/ASLP Logo3.png";
          updatePageChooseType(false, false, false, false, false);
          _image = null;
          _togglePause(_videoPlayerController ?? _cameraVideoPlayerController);
          print("Hamza");
          heightBackGround = 320;
          sharedPref.setString("prediction", "");
          _video = null;
          _cameraVideo = null;
          _cameraVideoPlayerController = null;
          _videoPlayerController = null;

          if (showbottomSignLanguageToWords) {
            if (Navigator.canPop(context)) Navigator.pop(context);
          } else {
            updateshowbottomSignLanguageToWords();
          }

          _Name = true;
        } else if (logo == "images/menu_icon2.jpeg") {
          if (showbottomSignup) {
            if (Navigator.canPop(context)) Navigator.pop(context);
          } else {
            updateshowbottomSignup();
          }

          _Name = true;
          setState(() {
            _change_language = false;
            _change_language = false;
            _drawer = true;
            logo_drawer_height = logo_drawer_height == 100 ? 200 : 100;
            logo_drawer_width = logo_drawer_width == 100 ? 200 : 100;
          });
        }
      }
    });
  }

  // Update background height
  void updateHeight() {
    setState(() {
      heightBackGround = 450;
    });
  }

  // Toggle bottom sheet for sign language to words
  void updateshowbottomSignLanguageToWords() {
    setState(() {
      showbottomSignLanguageToWords = !showbottomSignLanguageToWords;
    });
  }

  // Toggle bottom sheet for sign-up
  void updateshowbottomSignup() {
    setState(() {
      showbottomSignup = !showbottomSignup;
    });
  }

  bool isArabic = true; // Default language is Arabic
  // Toggle language (Arabic/English)
  void updateisArabic() {
    setState(() {
      isArabic = !isArabic;
    });
  }

  // Pick a video from the gallery
  _pickVideoFromGallery() async {
    final XFile? pickedFile =
        await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      _videoPlayerController?.dispose();

      _video = File(pickedFile.path);
      _videoPlayerController = VideoPlayerController.file(_video!)
        ..initialize().then((_) {
          setState(() {
            signlanguagetowords = true;
            wordstosignlanguage = false;
            learnletter = false;
            _cameraVideo = null; // Remove camera video if exists
            _cameraVideoPlayerController?.dispose(); // Dispose old controller
          });
        });
    }
  }

  // Pick a video from the camera
  _pickVideoFromCamera() async {
    final XFile? pickedFile =
        await picker.pickVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      _cameraVideoPlayerController?.dispose();
      _cameraVideo = File(pickedFile.path);
      _cameraVideoPlayerController = VideoPlayerController.file(_cameraVideo!)
        ..initialize().then((_) {
          setState(() {
            signlanguagetowords = true;
            wordstosignlanguage = false;
            learnletter = false;
            _video = null; // Remove gallery video if exists
            _videoPlayerController?.dispose(); // Dispose old controller
          });
        });
    }
  }

  // Launch the about page URL
  Future<void> _launchAboutPage() async {
    final Uri url = Uri.parse('https://sites.google.com/view/aslp-info/home');
    try {
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    widthBackGround = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
                child: Stack(children: [
      // Background image
      Container(
        child: Image.asset("images/v1066-069c 1.png"),
      ),
      // Animated background container
      AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: heightBackGround,
        width: widthBackGround,
        decoration: BoxDecoration(
          color: Color(0xFFBA33AB),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
      ),
      // Top bar with logo and icons
      Positioned(
        top: 30,
        right: 30,
        child: AnimatedContainer(
          height: heightBar,
          width: widthBar,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
          ),
          duration: Duration(milliseconds: 280),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Arrow icon or logo
              Visibility(
                visible: _Bar,
                child: Flexible(
                  child: iconn == "images/arrow_icon.png" ||
                          iconn == "images/arrow_icon - Copy.png"
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 60,
                            height: 20,
                            child: MaterialButton(
                              onPressed: logo_onPresed,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  iconn,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              iconn,
                              fit: BoxFit.cover,
                              height: 40,
                            ),
                          ),
                        ),
                ),
              ),
              // User name display
              Visibility(
                  visible: _Name,
                  child: Text(
                    isArabic
                        ? "${sharedPref.getString("username")} ${Arabic[10]}"
                        : "${English[10]} ${sharedPref.getString("username")}",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: isArabic ? "Arabic-sans" : "Racing-sans",
                        fontSize: 20),
                  )),
              // Logo or menu icon
              Visibility(
                visible: _logo_show,
                child: Flexible(
                    child: logo == "images/ASLP Logo3.png"
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                logo,
                                fit: BoxFit.cover,
                                height: 40,
                              ),
                            ),
                          )
                        : Container(
                            width: 55,
                            height: 50,
                            child: MaterialButton(
                              onPressed: () {
                                setState(() {
                                  _drawer = !_drawer;
                                  if (_drawer == true) {
                                    _Name = true;
                                    print("Presed");
                                    _drawer = true;
                                    logo_drawer_height = 470;
                                    logo_drawer_width = 310;
                                  }
                                });
                              },
                              child: Image.asset(
                                logo,
                                fit: BoxFit.cover,
                                height: 30,
                              ),
                            ),
                          )),
              ),
            ],
          ),
        ),
      ),
      // Sign-up screen
      Visibility(
        visible: _signup,
        child: Column(
          children: [
            Signupscreen(
              isArabic: isArabic,
              isLoading: isLoading,
              pickImageFromCamera: _pickImageFromCamera,
              pickImageFromGallery: _pickImageFromGallery,
              onSignupSuccess: _onSignupSuccess,
              updateshowbottomSignup: updateshowbottomSignup,
              updateVisibility: updatePageChooseType,
              reset_icon_logo: reset_icon_logo,
              textconvertController: _textconvertController,
              nameController: _nameController,
              emailController: _emailController,
              passwordController: _passwordController,
              showbottomSignup: showbottomSignup,
              image: _image,
            ),
            // Switch to login screen
            TextButton(
              onPressed: () {
                setState(() {
                  _signup = false;
                  _login = true;
                  showPageChoose = false;
                  _nameController.text = "";
                  _emailController.text = '';
                  _passwordController.text = '';
                  _image = null;
                });
              },
              child: Text(
                isArabic ? Arabic[8] : English[8],
                style: TextStyle(
                  fontFamily: isArabic ? "Arabic-sans" : "Racing-sans",
                  color: Color(0xFFBA33AB),
                ),
              ),
            ),
          ],
        ),
      ),
      // Page choose type screen
      Visibility(
          visible: showPageChoose,
          child: Pagechoosetype(
              isArabic: isArabic,
              updateHeight: updateHeight,
              updateshowbottomSignLanguageToWords:
                  updateshowbottomSignLanguageToWords,
              updateVisibility: updatePageChooseType,
              signlanguagetowords: signlanguagetowords,
              wordstosignlanguage: wordstosignlanguage,
              learnletter: learnletter,
              reset_icon_logo: reset_icon_logo,
              showbottomSignLanguageToWords: showbottomSignLanguageToWords,
              textconvertController: _textconvertController,
              pageshow: showPageChoose,
              updatePageShow: updateShowPage,
              // userimage: "${sharedPref.getString("pfp_url")}",
              isLoading: isLoading)),
      // Sign language to words screen
      Visibility(
          visible: signlanguagetowords,
          child: signlanguagetowords1 == true && signlanguagetowords2 == false
              ? Signlanguagetowords(
                  // togglePlayPause: _togglePlayPause,
                  isArabic: isArabic,
                  // updateshowbottomSignLanguageToWords:
                  //     updateshowbottomSignLanguageToWords,
                  isLoading: isLoading,
                  // showbottomSignLanguageToWords: showbottomSignLanguageToWords,
                  // image: _image,
                  // cameraVideo: _cameraVideo,
                  // video: _video,
                  // cameraVideoPlayerController: _cameraVideoPlayerController,
                  // videoPlayerController: _videoPlayerController,
                  // pickVideoFromCamera: _pickVideoFromCamera,
                  // pickVideoFromGallery: _pickVideoFromGallery,
                )
              : signlanguagetowords1 == false && signlanguagetowords2 == true
                  ? Signlanguagetowords2(
                      image: _image,
                      isLoading: isLoading,
                      updateShowChoose: updateshowbottomSignup,
                      isArabic: isArabic,
                      pickImageFromCamera: _pickImageFromCamera,
                      pickImageFromGallery: _pickImageFromGallery,
                      pageshow: showbottomSignup)
                  : Container()),
      // Words to sign language screen
      Visibility(
        visible: wordstosignlanguage,
        child: Wordstosignlanguage(
          updateShowBottomLetters: updateShowBottomLetters,
          showbottomLetters: showbottomLetters,
          isArabic: isArabic,
          textconvertController: _textconvertController,
        ),
      ),
      // Learn letters screen
      Visibility(
        visible: learnletter,
        child: Column(children: [
          SizedBox(
            height: 40,
          ),
          Column(children: [
            Text(
              isArabic ? Arabic[23] : English[23],
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontFamily: isArabic ? "Arabic-sans" : "Racing-sans",
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 600,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Containerchooselearn(
                    text: isArabic ? Arabic[24] : English[24],
                    font: isArabic ? "Arabic-sans" : "Racing-sans",
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Learn(
                            isLoading: isLoading,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ]),
        ]),
      ),
      // Login screen
      Visibility(
        visible: _login,
        child: Column(
          children: [
            Loginscreen(
              isArabic: isArabic,
              isLoading: isLoading,
              image: _image,
              nameController: _nameController,
              passwordController: _passwordController,
              onLoginSuccess: _onLoginSuccess,
              textconvertController: _textconvertController,
            ),
            // Switch to sign-up screen
            TextButton(
              onPressed: () {
                setState(() {
                  _login = false;
                  _signup = true;
                  showPageChoose = false;
                  showbottomSignLanguageToWords = false;
                });
              },
              child: isLoading == true
                  ? Container()
                  : Text(
                      isArabic ? Arabic[9] : English[9],
                      style: TextStyle(
                        fontFamily: isArabic ? "Arabic-sans" : "Racing-sans",
                        color: Color(0xFFBA33AB),
                      ),
                    ),
            ),
          ],
        ),
      ),
      // First page (Sign-up or Login)
      Visibility(
        visible: _firstpage,
        child: Positioned(
          top: 80,
          left: 50,
          bottom: 90,
          child: InkWell(
            onTap: () {
              setState(() {
                if (sharedPref.getString("email") != null ||
                    sharedPref.getString("pfp_url") != null ||
                    sharedPref.getString("id") != null) {
                  _login = false;
                  _signup = false;
                  showPageChoose = true;
                  _firstpage = false;

                  heightBackGround = 320;
                  iconn = "images/ASLP Logo3.png";
                  logo = "images/menu_icon2.jpeg";
                  _Bar = true;
                  widthBar = 350;
                  Future.delayed(Duration(milliseconds: 50), () {
                    _Name = true;
                    setState(() {});
                  });
                } else {
                  heightContenarSignuporLogin = 520;
                  _pagechooseSignuporLogin = true;
                  showbottomSignLanguageToWords = false;
                  showPageChoose = false;
                }
              });
            },
            child: Center(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 900),
                curve: Curves.bounceIn,
                height: heightContenarSignuporLogin,
                width: 275,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                  color: Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(21),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset("images/ASLP Logo2.png"),
                      ),
                      SizedBox(height: 40),
                      Visibility(
                        visible: _pagechooseSignuporLogin,
                        child: Column(
                          children: [
                            Buttonsignuporlogin(
                                onPressed: () {
                                  setState(() {
                                    showbottomSignLanguageToWords = false;
                                    heightBackGround = 113;
                                    widthBar = 350;
                                    _firstpage = false;
                                    _signup = true;
                                    _login = false;
                                    _Bar = true;
                                    showPageChoose = false;
                                  });
                                },
                                text: isArabic ? Arabic[0] : English[0],
                                font: isArabic ? "Arabic-sans" : "Racing-sans",
                                icon: Icons.note_add_rounded),
                            SizedBox(height: 30),
                            Buttonsignuporlogin(
                                onPressed: () {
                                  setState(() {
                                    showbottomSignLanguageToWords = false;
                                    heightBackGround = 113;
                                    widthBar = 350;
                                    _firstpage = false;
                                    _signup = false;
                                    _login = true;
                                    _Bar = true;
                                    showPageChoose = false;
                                  });
                                },
                                text: isArabic ? Arabic[1] : English[1],
                                font: isArabic ? "Arabic-sans" : "Racing-sans",
                                icon: Icons.login_rounded)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      // Drawer for settings and other options
      Visibility(
          visible: _drawer,
          child: Padding(
              padding: const EdgeInsets.only(top: 210),
              child: Center(
                  child: AnimatedContainer(
                      curve: Curves.easeIn,
                      duration: Duration(seconds: 8),
                      height: logo_drawer_height,
                      width: logo_drawer_width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0XFF1E1E1E)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                                height: 96,
                                width: 263,
                                decoration: BoxDecoration(
                                    color: Color(0XFF747474),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(children: [
                                      Container(
                                        width: 80,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                          border: Border.all(
                                              color: Colors.black, width: 3),
                                          borderRadius:
                                              BorderRadius.circular(120),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          child:
                                              sharedPref.getString("pfp_url") ==
                                                      'null'
                                                  ? Image.asset(
                                                      'images/image_person_icon.png',
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.network(
                                                      "${sharedPref.getString("pfp_url")}",
                                                      fit: BoxFit.cover,
                                                    ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            title: Text(
                                              "${sharedPref.getString("username")}",
                                              style: TextStyle(
                                                  fontFamily: "Racing-sans",
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            subtitle: Text(
                                              "${sharedPref.getString("email")}",
                                              style: TextStyle(
                                                  fontFamily: "Racing-sans",
                                                  color: Color.fromARGB(
                                                      255, 155, 155, 155),
                                                  fontSize: 8),
                                            ),
                                          ),
                                        ),
                                      )
                                    ]))),
                          ),
                          Settingsbutton(
                            text: isArabic ? Arabic[25] : English[25],
                            font: isArabic ? "Arabic-sans" : "Racing-sans",
                            icon: Icons.settings,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Settingspage(
                                    updateisArabic: updateisArabic,
                                    isArabic: isArabic,
                                    email: "${sharedPref.getString("email")}",
                                    image: "${sharedPref.getString("pfp_url")}",
                                    name:
                                        "${sharedPref.getString("username")}"),
                              ));
                            },
                            rightPadding: 10,
                            leftPadding: 0,
                          ),
                          Settingsbutton(
                            text: isArabic ? Arabic[26] : English[26],
                            font: isArabic ? "Arabic-sans" : "Racing-sans",
                            icon: Icons.history,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => History(
                                  isArabic: isArabic,
                                ),
                              ));
                            },
                            rightPadding: 0,
                            leftPadding: 0,
                          ),
                          Settingsbutton(
                            text: isArabic ? Arabic[27] : English[27],
                            font: isArabic ? "Arabic-sans" : "Racing-sans",
                            icon: Icons.logout,
                            rightPadding: 0,
                            leftPadding: 0,
                            onPressed: () {
                              setState(() {
                                sharedPref.clear();
                                print(sharedPref.getString("id"));
                                print(sharedPref.getString("pfp_url"));
                                _nameController.text = "";
                                _emailController.text = "";
                                _passwordController.text = "";
                                _drawer = false;
                                showPageChoose = false;
                                _Bar = true;
                                _login = true;
                                heightBackGround = 113;
                                widthBar = 350;
                                iconn = "images/arrow_icon.png";
                                logo = "images/ASLP Logo3.png";
                                _firstpage = false;
                                _Name = false;
                              });
                            },
                          ),
                          Settingsbutton(
                            text: isArabic ? Arabic[28] : English[28],
                            font: isArabic ? "Arabic-sans" : "Racing-sans",
                            icon: Icons.person,
                            onPressed: _launchAboutPage,
                            rightPadding: 30,
                            leftPadding: 0,
                          )
                        ],
                      ))))),
      // Language toggle button
      Visibility(
        visible: _signup == true ||
                _login == true ||
                showPageChoose == true ||
                signlanguagetowords == true ||
                wordstosignlanguage == true ||
                learnletter == true
            ? _change_language = false
            : _change_language = true,
        child: Padding(
            padding: EdgeInsets.all(30),
            child: Container(
              width: 57,
              height: 57,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(15)),
              child: IconButton(
                  onPressed: updateisArabic,
                  icon: Icon(
                    Icons.language,
                    size: 40,
                    color: Colors.white,
                  )),
            )),
      )
    ]))));
  }
}
