import 'package:flutter/material.dart';

class Checktrueorfalse extends StatelessWidget {
  String check;
  int count;
  Checktrueorfalse({super.key, required this.check, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: check == "None"
              ? Image.asset("images/white_image.jpeg")
              : check == "True"
                  ? Image.asset("images/trueIcon.png")
                  : Image.asset(
                      "images/falseIcon.png",
                    )),
    );
  }
}
