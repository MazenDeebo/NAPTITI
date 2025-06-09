import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../../shared.dart';
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
          results[0].diseaseName==S().healthy?
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
                    PreferenceUtils.getString(prefKeys.language)=="en"?disease.diseaseName:disease.diseaseNameArabic,
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900, color: Colors.white60),
                  ),
                  SizedBox(height: 20),
                  _buildInfoSection(S().description, S().noDetection),
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
                    PreferenceUtils.getString(prefKeys.language)=="en"?disease.diseaseName:disease.diseaseNameArabic,
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900, color: Colors.white60),
                  ),

                  _buildInfoSection(S().description,PreferenceUtils.getString(prefKeys.language)=="en"? disease.descriptionEnglish:disease.description),

                  PreferenceUtils.getBool(prefKeys.loggedIn)?
                  _buildInfoSection(S().cause,PreferenceUtils.getString(prefKeys.language)=="en"? disease.causeEnglish:disease.cause)
                      :
                  _blurredInfoSection(S().cause),

                  PreferenceUtils.getBool(prefKeys.loggedIn)?
                  _buildInfoSection(S().organicTreatment,PreferenceUtils.getString(prefKeys.language)=="en"? disease.organicTreatmentPlanEnglish:disease.organicTreatmentPlan)
                      :
                  _blurredInfoSection(S().organicTreatment),

                  PreferenceUtils.getBool(prefKeys.loggedIn)?
                  _buildInfoSection(S().chemicalTreatment,PreferenceUtils.getString(prefKeys.language)=="en"? disease.chemicalTreatmentPlanEnglish:disease.chemicalTreatmentPlan)
                      :
                  _blurredInfoSection(S().chemicalTreatment),

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
        alignment: Alignment.topRight,
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
  Widget _blurredInfoSection(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white60,
              fontSize: 29,
            ),
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.withOpacity(0.2),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    height: 80,
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.3),
                    alignment: Alignment.center,
                    child: Text(
                      S().loginToView,
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}