import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../shared.dart';
import '../../DetectionResult/Page/DetectionResultScreen.dart';
import '../../DetectionResult/Page/Diseases.dart';
import '../../Home/Page/Home.dart';


class UploadImageScreen extends StatefulWidget {
  UploadImageScreen({required this.chosenType});
  final String chosenType;
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}
void saveLogout() async{
  PreferenceUtils.setBool(prefKeys.loggedIn,false);
}
class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _selectedImage;

  Future<void> _takeImage() async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }
  Future<void> _pickImage() async{
    final pickedFile = await ImagePicker().pickImage(source:ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_after.png'), // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 40,),
              IconButton(
                  onPressed: (){
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Home()
                        )
                    );
                  },
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white)),
            ],
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Take an Image",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _takeImage,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CustomPaint(
                          painter: DashedCirclePainter(),
                        ),
                      ),
                      if (_selectedImage != null)
                        ClipOval(
                          child: Image.file(
                            _selectedImage!,
                            width: 180,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 50,
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF063A23),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minimumSize: Size(180, 50),
                  ),
                  child: Text("pick Image", style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedImage != null) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetectionResultScreen(
                            imageFile: _selectedImage!,
                            plantType: widget.chosenType.toLowerCase(),
                          ),
                        ),
                      );
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("take or pick an image first"),
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
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF063A23),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minimumSize: Size(180, 50),
                  ),
                  child: Text("Detect Diseases", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




class DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double radius = size.width / 2;
    double dashWidth = 13, dashSpace = 6;
    double totalCircumference = 2 * pi * radius;
    int dashCount = (totalCircumference / (dashWidth + dashSpace)).floor();

    for (int i = 0; i < dashCount; i++) {
      double startAngle = (i * (dashWidth + dashSpace)) / radius;
      double sweepAngle = dashWidth / radius;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


class PostDetectionResultScreen extends StatefulWidget {
  final File imageFile;
  final String plantType;

  const PostDetectionResultScreen({
    super.key,
    required this.imageFile,
    required this.plantType,
  });

  @override
  _PostDetectionResultScreenState createState() => _PostDetectionResultScreenState();
}


class _PostDetectionResultScreenState extends State<PostDetectionResultScreen> {
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    _getDetectionsAndNavigate();
  }

  Future<void> _getDetectionsAndNavigate() async {
    try {
      final fileName = widget.imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          widget.imageFile.path,
          filename: fileName,
        ),
        'plant_type': "${widget.plantType.toLowerCase()}",
      });
      final response = await dio.post(
        'https://my-app-154461300822.me-central1.run.app/predict',
        data: formData,
      );
      final result=DetectionResult.fromJson(response.data);
      final detection = result.detections;

      if (mounted) {
        if (detection.length>0){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DetectionResultScreen(
                imageFile: widget.imageFile!,
                results: detection,
                chosenType: widget.plantType,
              ),
            ),
          );
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("No leaves detected in the given image try uploading another  image"),
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
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => UploadImageScreen(
                      chosenType:"${widget.plantType.toLowerCase()}"
                  )
              )
          );
        }

      }
    } catch (e) {
      if (mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => UploadImageScreen(
                    chosenType:"${widget.plantType.toLowerCase()}"
                )
            )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_after.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', width: 100),
              SizedBox(height: 20),
              Text(
                "Detecting disease...",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
