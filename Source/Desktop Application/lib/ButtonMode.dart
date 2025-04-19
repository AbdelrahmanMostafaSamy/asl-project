import 'package:flutter/material.dart';

class Buttonmode extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final Color backgroundcolor;
  final void Function()? onPressed;
  final double height;
  final double width;
  String font;
  Buttonmode(
      {super.key,
      required this.font,
      required this.text,
      required this.color,
      required this.icon,
      required this.backgroundcolor,
      required this.onPressed,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundcolor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(icon, color: color),
            Center(
              child: Text(
                text,
                style: TextStyle(color: color, fontFamily: font, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
