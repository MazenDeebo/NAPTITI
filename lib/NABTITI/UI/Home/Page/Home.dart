import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../generated/l10n.dart';
import '../../../shared.dart';
import '../../Settings/page/settings.dart';
import '../../UploadImage/Page/UploadImageScreen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Color(0xFF063A23),
            title: Text(PreferenceUtils.getString(prefKeys.language)=="en"?'Exit App':"الخروج من التطبيق",style: TextStyle(color: Colors.white),),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(S().cancel,style: TextStyle(color: Colors.white),),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(S().exit,style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        );

        return shouldExit ?? false; // Exit only if true
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg_after.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Column(
              children: [
                SizedBox(height: 70),
                Center(
                  child: Text(
                    PreferenceUtils.getString(prefKeys.language) == "en"
                        ? "Select the desired plant"
                        : "حـدد نوع الـنبات",
                    style: GoogleFonts.cairo(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 5,
                          color: Colors.black45,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),

                Expanded(
                  child: ListView.builder(
                    itemCount: plantList.length,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    itemBuilder: (context, index) {
                      var plant = PreferenceUtils.getString(prefKeys.language)=="en"?plantList[index]:plantList2[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UploadImageScreen(chosenType: plantList[index]["name"]!),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(25),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Image.asset(
                                  plant['image']!,
                                  width: double.infinity,
                                  height: 160,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black45,
                                      ],
                                    ),
                                  ),
                                  child: Text(
                                    plant['name']!,
                                    style: GoogleFonts.cairo(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.support_agent, color: Colors.white, size: 30),
                        onPressed: () {
                          if (PreferenceUtils.getBool(prefKeys.loggedIn) == false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(S().guestChatMessage),
                                backgroundColor: Color(0xFF063A23),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                margin: EdgeInsets.only(left: 20, right: 20, bottom: 70),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          } else {
                            Navigator.pushReplacementNamed(context, '/chatbot');
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.settings, color: Colors.white, size: 30),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Settings()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, String>> plantList = [
  {"name": "Tomato", "image": "assets/tomato.png"},
  {"name": "Potato", "image": "assets/potato.png"},
  {"name": "Wheat", "image": "assets/wheat.png"},
];

final List<Map<String, String>> plantList2 = [
  {"name": "طماطم", "image": "assets/tomato.png"},
  {"name": "بطاطس", "image": "assets/potato.png"},
  {"name": "قمح", "image": "assets/wheat.png"},
];