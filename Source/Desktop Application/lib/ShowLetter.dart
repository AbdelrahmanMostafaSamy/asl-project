import 'package:flutter/material.dart';
import 'ButtonMode.dart';

class Showletter extends StatelessWidget {
  String image;
  String Letter;
  Showletter({super.key, required this.image, required this.Letter});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            body: Column(children: [
              Center(
                child: Container(
                  height: 57,
                  width: 360,
                  decoration: BoxDecoration(
                      color: const Color(0XFF747474),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      const SizedBox(width: 120),
                      Center(
                        child: Text(
                          "عرض حرف ${Letter}",
                          style: TextStyle(
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
              const SizedBox(height: 20),
              Container(
                height: 400,
                width: 280,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0XFF747474), width: 7),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: ClipRRect(
                  child: Image.asset("Assets/images/${Letter}.jpg"),
                ),
              ),
              const SizedBox(height: 20),
              Buttonmode(
                  font: "Arabic-sans",
                  text: "الرجوع",
                  color: Colors.white,
                  icon: Icons.arrow_back_ios_new,
                  backgroundcolor: const Color(0XFF747474),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  height: 60,
                  width: 150)
            ])));
  }
}
