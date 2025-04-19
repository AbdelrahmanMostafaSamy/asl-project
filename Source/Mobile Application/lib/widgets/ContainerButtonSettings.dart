import 'package:flutter/material.dart';

class Containerbuttonsettings extends StatelessWidget {
  final String text;
  final IconData icon;
  String font;
  final void Function()? onPressed;
  Containerbuttonsettings(
      {super.key,
      required this.text,
      required this.font,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: MaterialButton(
              onPressed: onPressed,
              child: Container(
                  height: 70,
                  width: 325,
                  decoration: BoxDecoration(
                      color: Color(0XFF747474),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        icon,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 70,
                      ),
                      Text(
                        text,
                        style: TextStyle(
                          fontFamily: font,
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),
            )));
  }
}
