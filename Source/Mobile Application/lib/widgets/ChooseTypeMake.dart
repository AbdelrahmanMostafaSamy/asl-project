import 'package:flutter/material.dart';

class Choosetypemake extends StatelessWidget {
  final String text;
  final IconData icon;
  String font;
  Choosetypemake(
      {super.key, required this.icon, required this.font, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 285,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3),
        ),
      ], color: Color(0XFFBA33AB), borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                size: 35,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              text,
              style: TextStyle(
                  fontFamily: font, fontSize: 17, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
