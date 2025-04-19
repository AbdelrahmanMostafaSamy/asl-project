import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:winapp/CameraScreen.dart';
import 'package:winapp/Historydata.dart';
import 'package:winapp/Home2.dart';
import 'package:winapp/LAScatagory.dart';
import 'package:winapp/WtoSl.dart';
import 'package:winapp/login.dart';
import 'package:window_manager/window_manager.dart';
import 'Home.dart';
import 'Aletters.dart';
import 'linksapp.dart';
import 'RnG.dart';
import 'Language.dart';



class History extends StatefulWidget {
  History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final Crud crud = Crud();
  List<Map<String, dynamic>> historyList = [];

  fetchHistory() async {
    var response =
        await crud.postRequest(linkHistory, {'id': globalID.toString()});

    if (response == null) {
      setState(() {
        historyList = [];
      });
    } else if (response['message'] == 'Not found') {
      setState(() {
        historyList = [];
      });
    } else {
      setState(() {
        historyList = List<Map<String, dynamic>>.from(response['data']);
      });
    }
  }

  ClearHistory(int id) async {
    var response = await crud.postRequest(
        LinkDeleteHistory, {'id': globalID.toString(), 'history_id': id});

    if (response!['message'] == 'History item deleted successfully') {
      const SnackBar(
        content: Text('History Deleted'),
      );
      setState(() {
        historyList.clear();
        fetchHistory();
      });
    } else {
      const SnackBar(
        content: Text('Failed to Delete'),
      );
    }
  }

  ClearAllHistory() async {
    var response = await crud
        .postRequest(LinkDeleteAllHistory, {'id': globalID.toString()});

    if (response == null) {
      const SnackBar(
        content: Text('Failed to delete history'),
      );
      return;
    }

    if (response['message'] == 'All history cleared successfully') {
      const SnackBar(
        content: Text('All History Deleted'),
      );
      setState(() {
        historyList.clear();
      });
    } else {
      const SnackBar(
        content: Text('Failed to delete all history'),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 57,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0XFF747474),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
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
                  Text(
                    isArabic! ? "سجل" : "History",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: isArabic! ? "Arabic-sans" :"Racing-sans",
                      fontSize: 23,
                    ),
                  ),
                  const SizedBox(width: 320),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: InkWell(
                      onTap: ClearAllHistory,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Icon(
                          Icons.delete,
                          size: 25,
                          color: Colors.grey[850],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: historyList.isEmpty
                  ? Center(
                      child: Text(
                        English[32],
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontFamily: isArabic! ? "Arabic-sans" : "Racing-sans",
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: historyList.length,
                      itemBuilder: (context, index) {
                        var historyItem = historyList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        historyItem["type"] == "Sign Language To Words"
                                            ? isArabic! ? Arabic[12] : English[12]
                                                          : historyItem["type"] == "Words To Sign Language"
                                                ?  isArabic! ? Arabic[13] : English[13]
                                                : "",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: isArabic! ? "Arabic-sans" : "Racing-sans",
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        historyItem["prediction"] ??
                                            "No Details",
                                        style: TextStyle(
                                          fontFamily: isArabic! ? "Arabic-sans" : "Racing-sans",
                                          color: Colors.white70,
                                          fontSize: 16,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      historyItem["date"] ?? "No Date",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: isArabic! ? "Arabic-sans" : "Racing-sans",
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.play_circle_fill,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Historydata(
                                                  isArabic: false,
                                                  type: historyItem["type"],
                                                  result:
                                                      historyItem["prediction"],
                                                  date:
                                                      "${historyItem["date"]}",
                                                  image:
                                                      "${historyItem["image"]}",
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              int? historyId =
                                                  historyItem["id"] as int?;
                                              if (historyId != null) {
                                                ClearHistory(historyId);
                                              }
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Icon(
                                                Icons.delete,
                                                size: 25,
                                                color: Colors.grey[850],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
