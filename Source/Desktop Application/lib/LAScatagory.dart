import 'package:flutter/material.dart';
import 'package:winapp/Letter_Images.dart';
import 'package:winapp/login.dart';
import 'RnG.dart';
import 'LearnLetter.dart';
import 'linksapp.dart';


class Learn extends StatefulWidget {
  bool isLoading;

  Learn({super.key, required this.isLoading});

  @override
  State<Learn> createState() => _LearnState();
}

class _LearnState extends State<Learn> {
  final Crud crud = Crud();
  List<Map<String, dynamic>> LearnList = [];

  fetchHistory() async {
    var response = await crud.postRequest(
      linkGetLearn,
      {'id': globalID.toString()},
    );

    if (response == null) {
      return;
    }

    if (response['message'] == 'Not found') {
      setState(() {
        LearnList = [];
      });
    } else {
      setState(() {
        LearnList = List<Map<String, dynamic>>.from(response["data"]);
      });
    }
  }

  reset_learn(String Letter) async {
    var response = await crud.postRequest(
      linkResetLearn,
      {'id': globalID.toString(), 'letter': Letter},
    );

    if (response == null) {
      _showSnackBar('فشل إعادة ضبط جميع الحروف');
      return;
    }

    if (response['message'] == 'Reset Success') {
      _showSnackBar('نجح إعادة ضبط جميع الحروف');
      setState(() {
        LearnList.clear();
        fetchHistory();
      });
    } else {
      _showSnackBar('فشل إعادة ضبط جميع الحروف');
    }
  }

  clearAllLetters() async {
    var response = await crud.postRequest(
      linkResetAllLearn,
      {'id': globalID.toString()},
    );

    if (response == null) {
      // إذا لم يكن هناك استجابة من الخادم
      _showSnackBar('فشل مسح جميع الحروف');
      return;
    }

    if (response['message'] == 'All letters cleared successfully') {
      // إذا نجحت العملية
      _showSnackBar('نجح مسح جميع الحروف');
      setState(() {
        LearnList.clear(); // مسح القائمة الحالية
        fetchHistory(); // إعادة جلب البيانات المحدثة
      });
    } else {
      // إذا فشلت العملية
      _showSnackBar('فشل مسح جميع الحروف');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 1),
        content: Text(
          message,
          style: TextStyle(fontFamily: 'Arabic-sans'),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Center(
              child: Container(
                height: 57,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0XFF747474),
                ),
                child: Row(
                  
                  children: [
                    SizedBox(width: 40),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 250),
                    const Text(
                      "تعليم لغة الأشارة العربية",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Arabic-sans",
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 250),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () {
                          clearAllLetters();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            "Assets/images/reset_icon3.png",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: LearnList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisExtent: 180,
                  mainAxisSpacing: 2,
                  childAspectRatio: 7 / 8,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    color: const Color(0XFF747474),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                LearnList[index]["Name"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 60,
                                  fontFamily: "Arabic-sans",
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  LearnList[index]["Description"],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontFamily: "Arabic-sans",
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: Image.asset(
                                    LearnList[index]["Done"] == "None"
                                        ? "Assets/images/white_image.jpeg"
                                        : LearnList[index]["Done"] == "True"
                                            ? "Assets/images/trueIcon.png"
                                            : "Assets/images/falseIcon.png",
                                  ),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    reset_learn(LearnList[index]["Name"]);
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      "Assets/images/reset_icon3.png",
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    final result =
                                        await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => Learnletter(
                                          data: LearnList,
                                          isLoading: widget.isLoading,
                                          Image: Images[index],
                                          Letter: LearnList[index]["Name"],
                                          Done: LearnList[index]["Done"],
                                        ),
                                      ),
                                    );

                                    if (result == true) {
                                      setState(() {});
                                      LearnList.clear();
                                      Future.delayed(
                                          Duration(milliseconds: 100), () {
                                        fetchHistory(); // تحديث البيانات إذا تم تعلم الحرف
                                      });
                                    }
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      "Assets/images/playIcon.png",
                                    ),
                                  ),
                                ),
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
