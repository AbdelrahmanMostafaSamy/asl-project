import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:winapp/CameraScreen.dart';
import 'package:winapp/LAScatagory.dart';
import 'package:winapp/LiveScreen.dart';
import 'package:winapp/RecordScreen.dart';
import 'package:winapp/WtoSl.dart';
import 'package:winapp/history.dart';
import 'package:winapp/login.dart';
import 'package:window_manager/window_manager.dart';
import 'Home.dart';
import 'Aletters.dart';
import 'linksapp.dart';

bool? isArabic = false;

Future<void> _toggleLanguagePreference() async {
  final prefs = await SharedPreferences.getInstance();
  isArabic = !(prefs.getBool('isArabic') ?? false);
  await prefs.setBool('isArabic', isArabic!);
}

Future<void> _loadLanguagePreference() async {
  final prefs = await SharedPreferences.getInstance();
  isArabic = prefs.getBool('isArabic') ?? false;
}

@override
void initState() {
  _loadLanguagePreference();
}


class home extends StatefulWidget {
  home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  bool isLoading = false;

  Future<void> _launchAboutPage() async {
    final Uri _url = Uri.parse(
        WebsiteLink);
    if (!await launchUrl(
      _url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $_url';
    }
  }


  @override
  Widget build(BuildContext context) {
    windowManager.setSize(const Size(860, 600));
    windowManager.setResizable(false);
    windowManager.setTitleBarStyle(TitleBarStyle.normal);
    windowManager.setTitle("Arabic Sign Language Project | Home");
    Window.setEffect(
      effect: WindowEffect.mica,
      dark: false,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        backgroundColor:
            const Color(0xFF3A1D45), // Background color of the drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header (Profile Section)
            Container(
              padding: const EdgeInsets.all(16.0),
              color: const Color(0xFF3A1D45),
              child: Row(
                children: [
                  // Placeholder for profile picture
                  CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      backgroundImage: globalPFP != null &&
                              globalPFP!.isNotEmpty
                          ? NetworkImage(globalPFP!)
                          : const AssetImage('Assets/Images/PfpNotAdded.png')
                              as ImageProvider),
                  const SizedBox(width: 10),
                  // Placeholder for user name and email
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$globalName",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "$globalEmail",
                        style: TextStyle(
                          fontSize: globalEmail!.length > 20 ? 12 : 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Language Drawer with Toggle Switch
            ListTile(
              leading: Icon(Icons.language, color: Colors.white),
              title: Text(isArabic! ? "واجهة باللغة العربية" :
                "Arabic UI",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Switch(
                value: isArabic ?? false,
                onChanged: (value) async {
                  await _toggleLanguagePreference();
                  setState(() {});
                  if (isArabic!) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم التبديل بنجاح!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Switched Successfully!')),
                    );
                  }
                },
                activeColor: Colors.white,
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.white,
              ),
              onTap: () {
              },
            ),

            _buildDrawerItem(
              icon: Icons.history,
              text: isArabic! ? "سجل":"History",
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => History(),
                ));
              },
            ),
            _buildDrawerItem(
              icon: Icons.logout,
              text: isArabic! ? "تسجيل الخروج":"Logout",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logout successful!')),
                );
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const choice(),
                ));
              },
            ),
            _buildDrawerItem(
              icon: Icons.info,
              text: isArabic! ? "نبذة عن مشروعنا":"About Our Project",
              onTap: _launchAboutPage,
            ),
          ],
        ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('Assets/Images/background.jpg'),
                fit: BoxFit.cover,
                opacity: 0.1,
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: SizedBox(
              height: 290,
              width: 850,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: const Color(0xffBA33AB),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ]),
              ),
            ),
          ),
          Positioned(
              top: 50,
            child: CircleAvatar(
                radius: 75,
                backgroundColor: Colors.white,
                backgroundImage: globalPFP != null &&
                    globalPFP!.isNotEmpty
                    ? NetworkImage(globalPFP!)
                    : const AssetImage('Assets/Images/PfpNotAdded.png')
                as ImageProvider),
          ),
           Positioned(
              top: 210,
              child: Text(isArabic! ? "!$globalName مرحبا" :
                "Welcome ${globalName}!",
                style: const TextStyle(
                  fontSize: 23,
                  fontFamily: "Racing Sans One",
                  color: Colors.white,
                ),
              )),
          Positioned(
            bottom: 20,
            child: SizedBox(
              height: 265,
              width: 285,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: const Color(0xffD9D9D9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ]),
              ),
            ),
          ),
          Positioned(
              bottom: 45,
              child: Column(
                children: [
                  _buildButton(
                    text: isArabic! ? "لغة الإشارة إلى الكلمات" :"Sign Language to Words",
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(isArabic! ? "اختر الوسائط" : "Choose Media"),
                            content: Text(isArabic! ? "يرجى اختيار نوع الوسائط" : "Please choose the type of media"),
                            actions: <Widget>[
                              TextButton(
                                child: Text(isArabic! ? "صورة" : "Image"),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CameraScreen(),
                                  ));
                                },
                              ),
                              TextButton(
                                child: Text(isArabic! ? "مباشر" : "Live"),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LiveScreen(),
                                  ));
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  _buildButton(
                    text: isArabic! ? "الكلمات إلى لغة الإشارة":"Words to Sign Language",
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Wtosl(),
                      ));
                    },
                  ),
                  const SizedBox(height: 40),
                  _buildButton(
                    text: isArabic! ? "تعلم لغة الإشارة العربية" : "Learn Arabic Sign Language",
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Learn(isLoading: isLoading,),
                      ));
                    },
                  ),
                ],
              )),
          Positioned(
            top: 20.0,
            left: 16.0,
            child: Builder(
              builder: (context) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black87,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Drawer Item Builder
  Widget _buildDrawerItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        height: 45,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFBA33AB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Button Builder
  Widget _buildButton({required String text, required VoidCallback onTap}) {
    return SizedBox(
      height: 43,
      width: 263,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffBA33AB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          shadowColor: Colors.black.withOpacity(0.25),
          elevation: 4,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: "Racing Sans One",
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

