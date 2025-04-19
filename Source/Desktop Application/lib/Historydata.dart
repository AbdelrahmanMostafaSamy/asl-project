import 'package:flutter/material.dart';
import 'language.dart';
import 'Home2.dart';


class Historydata extends StatelessWidget {
  String image;
  String date;
  String result;
  String type;
  bool isArabic;

  Historydata(
      {super.key,
      required this.image,
      required this.date,
      required this.result,
      required this.type,
      required this.isArabic}
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Column(children: [
          const SizedBox(
            width: 100,
          ),
          Container(
            height: 60,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: const Color(0XFF747474),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 350),
                // const Spacer(),
                Text(
                  "Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: isArabic ? "Arabic-sans" : "Racing-sans",
                    fontSize: 23,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          const SizedBox(height: 50),

          Row(
            children: [
              const SizedBox(width: 10),
              Container(
                  height: 400,
                  width: 500,
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0XFF747474), width: 7),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                    ),
                  )),
              const SizedBox(width: 20),
                  Container(
            height: 200,
            width: 300,
            decoration: BoxDecoration(
                color: const Color(0XFF747474),
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text(
                        isArabic ? Arabic[34] : English[34],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily:
                                isArabic ? "Arabic-sans" : "Racing-sans"),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        type,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  
                  Row(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        isArabic ? Arabic[35] : English[35],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily:
                                isArabic ? "Arabic-sans" : "Racing-sans"),
                      ),
                      SizedBox(height: 10),
                      Text(
                        date,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        isArabic ? Arabic[36] : English[36],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily:
                                isArabic ? "Arabic-sans" : "Racing-sans"),
                      ),
                      SizedBox(height: 10),
                      Text(
                        result,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        
            ],
          ),
        ])));
  }
}
