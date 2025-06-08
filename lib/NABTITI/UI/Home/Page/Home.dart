import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../../shared.dart';
import '../../Settings/page/settings.dart';
import '../../UploadImage/Page/UploadImageScreen.dart';

void saveLogout() async{
  PreferenceUtils.setBool(prefKeys.loggedIn,false);
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: _buildBottomNavBar(context),
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
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    PreferenceUtils.getString(prefKeys.language)=="en"?
                    "Select the desired plant"
                        :
                    "اختر نوع النبات",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: plantList.map((plant) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(
                                builder: (context) => UploadImageScreen(chosenType:"${plant["name"]}")
                            )
                            );
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: 200,
                            height: 190,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(plant['image'] ?? 'assets/default.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            alignment: Alignment.center,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
final List<Map<String, String>> plantList = [
  {"name": "Tomato", "image": "assets/tomato.png"},
  {"name": "Potato", "image": "assets/potato.png"},
  {"name": "Wheat", "image": "assets/wheat.png"},
];

Widget _buildBottomNavBar(BuildContext context) {
  return BottomNavigationBar(
    backgroundColor: Color(0xFF063A23),
    elevation: 0,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: S().home),
      BottomNavigationBarItem(icon: Icon(Icons.chat), label: S().chatbot),
      BottomNavigationBarItem(icon: Icon(Icons.settings), label: S().setting),
    ],
    onTap: (index) {
      print("==========================${PreferenceUtils.getBool(prefKeys.loggedIn)}");
        if (index == 0) {
          //Navigator.pushNamed(context, '/home');
        }
        else if (index == 1){
          if (PreferenceUtils.getBool(prefKeys.loggedIn) == false){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S().guestChatMessage),
                backgroundColor: Color(0xFF063A23),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(20)
                  ),
                ),
                margin: EdgeInsets.all(20),
                duration: Duration(seconds: 3),
              ),
            );
          }
          else{
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.pushReplacementNamed(context, '/chatbot');
          }
        }
        else if (index == 2){
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context)=> Settings())
          );
        }
    },

  );

}

