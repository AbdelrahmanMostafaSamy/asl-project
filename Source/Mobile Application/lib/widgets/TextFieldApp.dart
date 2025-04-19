import 'package:flutter/material.dart';

class TextFieldApp extends StatelessWidget {
  String Name;
  TextInputType Type;
  Icon PrefixIcon;
  bool obs;
  String font;
  final TextEditingController controller;
  final String? Function(String?) validator;

  TextFieldApp(
      {super.key,
      required this.Name,
      required this.Type,
      required this.PrefixIcon,
      required this.obs,
      required this.font,
      required this.controller,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      width: 285,
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obs,
        keyboardType: Type,
        maxLines: 1,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black, width: 3.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black, width: 5.0),
          ),
          contentPadding: EdgeInsets.all(10),
          prefixIcon: PrefixIcon,
          filled: true,
          fillColor: Color(0xFFD9D9D9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black, width: 1.5),
          ),
          hintText: Name,
          hintStyle: TextStyle(
            fontFamily: font,
            fontSize: 22,
          ),
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
    );
  }
}
