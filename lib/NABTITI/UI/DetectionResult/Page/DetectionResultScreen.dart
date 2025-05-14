import 'dart:io';
import 'package:flutter/material.dart';

class DetectionResultScreen extends StatelessWidget {
  final File imageFile;
  final String diseaseName;
  final String cause;
  final String organicTreatment;
  final String chemicalTreatment;

  DetectionResultScreen({
    required this.imageFile,
    required this.diseaseName,
    required this.cause,
    required this.organicTreatment,
    required this.chemicalTreatment,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavBar(context),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_after.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 40),
                // Display Detected Leaf Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.file(
                    imageFile,
                    height: 200,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                // Title
                Text(
                  diseaseName,
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900, color: Colors.white60),
                ),
                SizedBox(height: 20),

                // Details
                _buildInfoSection("Cause:", cause),
                _buildInfoSection("Organic Treatment:", organicTreatment),
                _buildInfoSection("Chemical Treatment:", chemicalTreatment),

                SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black87, fontSize: 20),
            children: [
              TextSpan(text: '$title\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 29)),
              TextSpan(text: content),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildBottomNavBar(BuildContext context) {
  return BottomNavigationBar(
    backgroundColor: Colors.green[800],
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white70,
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.chat), label: "ChatBot"),
    ],
    onTap: (index) {
      if (index == 0) {
        Navigator.pushNamed(context, '/home');
      } else if (index == 1) {
        Navigator.pushNamed(context, '/chatbot');
      }
    },
  );
}
