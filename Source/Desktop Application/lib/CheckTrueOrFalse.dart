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
              ? Image.asset(
                  // widget.data[index]["Done"] == "true"
                  "Assets/images/white_image.jpeg"
                  //     : "images/falseIcon.png",
                  )
              : check == "True"
                  ? Image.asset(
                      // widget.data[index]["Done"] == "true"
                      "Assets/images/trueIcon.png"
                      //     : "images/falseIcon.png",
                      )
                  : Image.asset(
                      // widget.data[index]["Done"] == "true"
                      "Assets/images/falseIcon.png",
                    )),
    );
  }
}
