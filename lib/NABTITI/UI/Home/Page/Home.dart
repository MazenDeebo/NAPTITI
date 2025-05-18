import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../shared.dart';
import '../../Landing/page/landing.dart';

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
              mainAxisSize: MainAxisSize.min, // Keeps the column compact
              children: [
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
                                arguments: plant['name'],
                              );
                            },
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              width: 200,
                              height: 200,
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


Widget _buildBottomNavBar(BuildContext context) {
  return BottomNavigationBar(
    backgroundColor: Color(0xFF063A23),
    elevation: 0,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.chat), label: "ChatBot"),
      BottomNavigationBarItem(icon: Icon(Icons.logout), label: "LogOut"),
    ],
    onTap: (index) {
        if (index == 0) {
          //Navigator.pushNamed(context, '/home');
        }
        else if (index == 1){
          if (PreferenceUtils.getBool(prefKeys.loggedIn) == false){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Log in to use the chat bot")),
            );
          }
          else{
            Navigator.pushNamed(context, '/chatbot');
          }
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


final List<Map<String, String>> plantList = [
  {"name": "Tomato", "image": "assets/tomato.png"},
  {"name": "Potato", "image": "assets/potato.png"},
  {"name": "Wheat", "image": "assets/wheat.png"},
];

