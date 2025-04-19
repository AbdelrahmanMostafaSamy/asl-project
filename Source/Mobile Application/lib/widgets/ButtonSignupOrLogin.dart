import 'package:flutter/material.dart';

class Buttonsignuporlogin extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final IconData icon;
  final String font;
  Buttonsignuporlogin(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.icon,
      required this.font});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 61,
      width: 241,
      decoration: BoxDecoration(
        color: Color(0xFFBA33AB),
        borderRadius: BorderRadius.circular(18),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
            SizedBox(
              width: 35,
            ),
            Text(
              text,
              style: TextStyle(
                fontFamily: font,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
