import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../shared.dart';
import '../../Landing/page/landing.dart';
import '../../Login/Page/LoginScreen.dart';

void saveLogout() async{
  PreferenceUtils.setBool(prefKeys.loggedIn,false);
}
// 🔹 PLANT SELECTION SCREEN
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: _buildBottomNavBar(context),
      body: Stack(
        children: [
          // Background Image
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

          // Centering Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Keeps the column compact
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Select the desired plant",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Scrollable Plant Selection List
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: plantList.map((plant) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/upload',
                                arguments: plant['name'], // Pass plant name
                              );
                            },
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              width: 200, // Button width
                              height: 200, // Button height
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: AssetImage(plant['image'] ?? 'assets/default.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.all(10),
                              ),
                            ),
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

// Bottom Navigation Bar
Widget _buildBottomNavBar(BuildContext context) {
  return BottomNavigationBar(
    backgroundColor: Colors.green[800],
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white70,
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.chat), label: "ChatBot"),
      BottomNavigationBarItem(icon: Icon(Icons.logout), label: "LogOut"),
    ],
    onTap: (index) {
      if (index == 0) {
        Navigator.pushNamed(context, '/home');
      }
      else if (index == 1){
        Navigator.pushNamed(context, '/chatbot');
      }
      else if (index == 2){
        saveLogout();
        FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context)=> LandingScreen())
        );
      }
    },
  );
}

// List of Plants
final List<Map<String, String>> plantList = [
  {"name": "Tomato", "image": "assets/tomato.png"},
  {"name": "Potato", "image": "assets/potato.png"},
  {"name": "Wheat", "image": "assets/wheat.png"},
];

