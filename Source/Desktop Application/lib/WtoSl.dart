import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:winapp/Home2.dart';
import 'package:window_manager/window_manager.dart';
import 'package:winapp/linksapp.dart';
import 'package:winapp/login.dart';
import 'Home2.dart';
import 'RnG.dart';
import 'package:url_launcher/url_launcher.dart';

class Wtosl extends StatefulWidget {
  
  const Wtosl({super.key});
  
  @override
  State<Wtosl> createState() => _WtoslState();
}

class _WtoslState extends State<Wtosl> {
  final TextEditingController textconvertController = TextEditingController();
  Crud crud = Crud();

  String Gif = "";

  Future<void> Convert(String sentence) async {
    var response = await crud.postRequest(
      linkTextToSign,
      {'id': globalID.toString(), "sentence": sentence},
    );

    if (response == null) {
      return;
    }

    if (response['message'] == 'Not found') {
      print("Error");
    } else if (response['message'] == 'Correct') {
      setState(() {
        Gif = response['file_name'];
      });
    }
  }

  Future<void> _launchAboutPage() async {
    final Uri url =
        Uri.parse('https://chat.whatsapp.com/GAgm3l2a1zNISYsVYHuWM7');
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
    windowManager.setSize(const Size(860, 600));
    windowManager.setResizable(false);
    windowManager.setTitleBarStyle(TitleBarStyle.normal);
    windowManager.setTitle("Arabic Sign Language Project");
    Window.setEffect(
      effect: WindowEffect.mica,
      dark: false,
    );
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
                      ]),
                ),
              ),
            ),
            Positioned(
              top: 50,
              child: SizedBox(
                height: 347,
                width: 596,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      border: Border.all(color: Colors.black, width: 1),
                      color: const Color(0xff9F9D9D),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ]),
                  child: Gif.isEmpty ? Image.asset("Assets/images/ASL-removebg-preview 1.png") : Image.network(Gif),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: SizedBox(
                height: 150,
                width: 370,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25)),
                        border: Border.all(color: Colors.black, width: 1),
                        color: const Color(0xffD9D9D9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ]),
                    child: Column(children: [
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 300,
                        height: 32,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: isArabic! ?  "ادخل كلمة":"Enter Prompt",
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.all(8),
                          ),

                          controller: textconvertController,
                          style: const TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                          
                          cursorColor: Colors.blue,
                          cursorWidth: 2,
                          cursorRadius: const Radius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        height: 45,
                        width: 170,
                        decoration: const BoxDecoration(
                          color: Color(0xffBA33AB),
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            Convert(textconvertController.text);
                            
                          },
                          child: Text( isArabic! ? "تحويل":"Convert",
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Segoe UI',),
                          ),
                        ),
                      ),
                    ])),
              ),
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
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => home(),
                    ));
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
