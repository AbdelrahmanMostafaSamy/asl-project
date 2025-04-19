import 'package:flutter/material.dart';

class Containerchooselearn extends StatelessWidget {
  final String text;
  final String? font;
  final void Function()? onPressed;

  Containerchooselearn({
    super.key,
    required this.text,
    required this.onPressed,
    this.font,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        height: 60,
        width: 360,
        child: MaterialButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Icon(
                Icons.sign_language,
                size: 30,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontFamily: font ?? 'DefaultFont',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
