import 'package:flutter/material.dart';

class Settingsbutton extends StatelessWidget {
  final Function()? onPressed;
  final String text;
  final IconData icon;
  final double rightPadding;
  final double leftPadding;
  final String font;
  Settingsbutton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.icon,
      required this.rightPadding,
      required this.leftPadding,
      required this.font});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: MaterialButton(
              onPressed: onPressed,
              child: Container(
                  height: 45,
                  width: 260,
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
                        width: 35,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: leftPadding, right: rightPadding),
                        child: Text(
                          text,
                          style: TextStyle(
                            fontFamily: font,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )),
            )));
  }
}
