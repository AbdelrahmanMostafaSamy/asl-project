import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sign_language_app/More_Data/Language.dart';
import 'package:sign_language_app/contscat/crud.dart';
import 'package:sign_language_app/contscat/linksapp.dart';
import 'package:sign_language_app/main.dart';
import 'package:sign_language_app/widgets/ButtonMode.dart';
import 'package:sign_language_app/widgets/ContainerChooseOption.dart';
import 'package:sign_language_app/widgets/IconButtonApp.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class Signlanguagetowords2 extends StatefulWidget {
  final File? image;
  final dynamic pickImageFromGallery;
  final dynamic pickImageFromCamera;
  final bool pageshow;
  bool isArabic;
  bool isLoading;
  final Function updateShowChoose;

  Signlanguagetowords2({
    super.key,
    required this.isLoading,
    required this.updateShowChoose,
    required this.image,
    required this.isArabic,
    required this.pickImageFromCamera,
    required this.pickImageFromGallery,
    required this.pageshow,
  });

  @override
  State<Signlanguagetowords2> createState() => _SignlanguagetowordsState();
}

class _SignlanguagetowordsState extends State<Signlanguagetowords2> {
  API api = API();

  void _closeBottom() {
    setState(() {
      widget.updateShowChoose();
    });
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

  void _choose_camera_or_gallery() {
    showBottomSheet(
      context: context,
      builder: (context) {
        return Visibility(
          visible: widget.pageshow,
          child: Container(
            height: 280,
            width: 310,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 3,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      height: 5,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 60),
                Container(
                  height: 48,
                  width: 285,
                  decoration: BoxDecoration(
                    color: Color(0XFFBA33AB),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Containerchooseoption(
                    font: widget.isArabic ? "Arabic-sans" : "Racing-sans",
                    text: widget.isArabic ? Arabic[18] : English[18],
                    onPressed: widget.pickImageFromGallery,
                    icon: Icons.photo_library_outlined,
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  height: 48,
                  width: 285,
                  decoration: BoxDecoration(
                    color: Color(0XFFBA33AB),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Containerchooseoption(
                    font: widget.isArabic ? "Arabic-sans" : "Racing-sans",
                    text: widget.isArabic ? Arabic[19] : "Take Photo",
                    onPressed: () async {
                      File? newVideo = await widget.pickImageFromCamera();
                      if (newVideo == null) {
                        print('No video selected');
                      }
                    },
                    icon: Icons.photo_camera,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void check() async {
    if (widget.image == null) {
      _showSnackBar(widget.isArabic ? "لا يوجد صورة" : 'No image provided');
      return;
    }

    try {
      Uint8List bytes = await widget.image!.readAsBytes();
      setState(() {
        widget.isLoading = true;
      });

      var response = await api.postRequest(LinkModel, {
        'image': base64Encode(bytes),
        'type': "Sign Language To Words",
        'id': sharedPref.getString('id'),
      });
      setState(() {
        widget.isLoading = false;
      });

      if (response == null) {
        _showSnackBar(widget.isArabic
            ? "يوجد مشكله فى الصورة"
            : 'No response from server');
        sharedPref.setString("prediction", "No Result");
        return;
      }

      if (response['error'] == 'No image') {
        _showSnackBar(
            widget.isArabic ? "يجب أدخال صورة" : 'Please input a valid image');
      } else if (response['error'] == 'No hand detected') {
        sharedPref.setString("prediction", "No Hand Detected");
        _showSnackBar(widget.isArabic ? "لا يوجد يد" : 'No hand detected');
      } else if (response['prediction'] != null) {
        sharedPref.setString("prediction", response['prediction']);
        _showSnackBar('${response['prediction']} : الناتج ');
        result = true;
      } else {
        sharedPref.setString("prediction", "No Result");
        _showSnackBar('Unexpected response');
      }
    } catch (e) {
      setState(() {
        widget.isLoading = false;
      });
      sharedPref.setString("prediction", "No Result");
      _showSnackBar('An error occurred: $e');
    }
  }

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
                child: widget.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Color(0XFFBA33AB),
                        ),
                      )
                    : widget.image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.file(
                              widget.image!,
                              fit: BoxFit.contain,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              "images/ASLP Logo4.png",
                              fit: BoxFit.contain,
                            ),
                          ),
              ),
              Positioned(
                bottom: -1,
                child: Container(
                  width: 110,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.black, width: 5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Iconbuttonapp(
                        color: Color(0XFFBA33AB),
                        colorIcon: Colors.white,
                        icon: Icons.add,
                        onPressed: () {
                          _choose_camera_or_gallery();
                          widget.updateShowChoose();
                        },
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      // Iconbuttonapp(
                      //   color: Color(0XFFBA33AB),
                      //   colorIcon: Colors.white,
                      //   icon: Icons.add,
                      //   onPressed: () {
                      //     _choose_camera_or_gallery();
                      //     widget.updateShowChoose();
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
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
          Row(
            children: [
              SizedBox(width: 55),
              Buttonmode(
                font: widget.isArabic ? "Arabic-sans" : "Racing-sans",
                text: widget.isArabic ? "ارسال" : "Send",
                width: 130,
                height: 48,
                color: Colors.white,
                icon: Icons.send_to_mobile,
                backgroundcolor: Color(0XFFBA33AB),
                onPressed: check,
              ),
              SizedBox(width: 40),
              Buttonmode(
                font: widget.isArabic ? "Arabic-sans" : "Racing-sans",
                width: 130,
                height: 48,
                text: widget.isArabic ? "عرض" : "Show",
                color: Colors.black,
                icon: Icons.text_fields,
                backgroundcolor: Color(0XFF9F9D9D),
                onPressed: () {
                  setState(() {
                    result = !result;
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextButton(
              onPressed: _launchAboutPage,
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
