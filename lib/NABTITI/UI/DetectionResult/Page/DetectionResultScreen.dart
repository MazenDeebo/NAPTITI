import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../shared.dart';
import '../../Landing/page/landing.dart';
import '../../UploadImage/Page/UploadImageScreen.dart';
import 'Diseases.dart';

class DetectionResultScreen extends StatelessWidget {
  final File imageFile;
  final List<Detections> results;
  final String chosenType;

  DetectionResultScreen({
    required this.imageFile,
    required this.results,
    required this.chosenType
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_after.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          results[0].diseaseName=="Healthy"?
          ListView.builder(
            itemCount: results.length,
            itemBuilder:(context,index){
              Detections disease=results[index];
              return Column(
                children: [
                  SizedBox(height: 90),
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
                  Text(
                    disease.diseaseName,
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900, color: Colors.white60),
                  ),
                  SizedBox(height: 20),
                  _buildInfoSection("Description:", "no Diseases detected in your plant"),
                ],
              );
            },
          )
              :
          ListView.builder(
            itemCount: results.length,
            itemBuilder:(context,index){
              Detections disease=results[index];
              return Column(
                children: [
                  SizedBox(height: 90),
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
                  Text(
                    disease.diseaseName,
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900, color: Colors.white60),
                  ),
                  SizedBox(height: 20),
                  _buildInfoSection("Description:", disease.description),
                  _buildInfoSection("Cause:", disease.cause),
                  _buildInfoSection("Organic Treatment:", disease.organicTreatmentPlan),
                  _buildInfoSection("Chemical Treatment:", disease.chemicalTreatmentPlan),

                ],
              );

            },
          ),
          Column(
            children: [
              SizedBox(height: 40,),
              IconButton(
                  onPressed: (){
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UploadImageScreen(
                              chosenType: chosenType,
                            ),
                        )
                    );
                  },
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white)),
            ],
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
              TextSpan(text: '$title\n', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white60, fontSize: 29)),
              TextSpan(text: content),
            ],
          ),
        ),
      ),
    );
  }
}