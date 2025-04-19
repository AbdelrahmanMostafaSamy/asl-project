import 'package:flutter/material.dart';

class Iconbuttonapp extends StatelessWidget {
  final Color color;
  final Color colorIcon;
  final IconData icon;
  final void Function()? onPressed;
  Iconbuttonapp(
      {super.key,
      required this.color,
      required this.colorIcon,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: colorIcon,
          ),
        ),
      ),
    );
  }
}
