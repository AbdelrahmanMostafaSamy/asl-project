import 'package:flutter/material.dart';

class Containerchooseoption extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final IconData icon;
  String font;
  Containerchooseoption(
      {super.key,
      required this.text,
      required this.font,
      required this.onPressed,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 285,
      decoration: BoxDecoration(
          color: Color(0XFFBA33AB), borderRadius: BorderRadius.circular(30)),
      child: MaterialButton(
        onPressed: onPressed,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              SizedBox(
                width: 15,
              ),
              Text(text,
                  style: TextStyle(color: Colors.white, fontFamily: font)),
            ],
          ),
        ),
      ),
    );
  }
}
