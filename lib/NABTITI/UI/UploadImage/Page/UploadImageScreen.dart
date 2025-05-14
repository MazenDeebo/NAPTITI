import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../DetectionResult/Page/DetectionResultScreen.dart';


// 🔹 UPLOAD IMAGE SCREEN
class UploadImageScreen extends StatefulWidget {
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _selectedImage; // Store the captured image

  // Function to open the camera
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Store image in state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String plantName =
        ModalRoute.of(context)?.settings.arguments as String? ?? "Unknown";

    return Scaffold(
      bottomNavigationBar: _buildBottomNavBar(context),
      body: Stack(
        children: [
          // Background Image
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

          // Centering Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  "Upload an Image",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),

                // Circular Camera Button
                GestureDetector(
                  onTap: _pickImage, // Open camera on tap
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Dashed Circle
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CustomPaint(
                          painter: DashedCirclePainter(),
                        ),
                      ),
                      // Display Image if Selected
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

                // Add Image Button
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minimumSize: Size(180, 50),
                  ),
                  child: Text("Add Image", style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 15),

                // Approve Button
                ElevatedButton(
                  onPressed: () {
                    if (_selectedImage != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetectionResultScreen(
                            imageFile: _selectedImage!,
                            diseaseName: 'Early Blight',
                            cause: 'Caused by the fungus *Alternaria solani*, often due to warm, wet conditions.',
                            organicTreatment: 'Neem oil spray, crop rotation, and compost tea.',
                            chemicalTreatment: 'Chlorothalonil or Mancozeb-based fungicides.',
                          ),
                        ),
                      );
                    }
                  }
                  ,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minimumSize: Size(180, 50),
                  ),
                  child: Text("Approve", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



// Custom Painter for Dashed Circular Border
class DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double radius = size.width / 2;
    double dashWidth = 10, dashSpace = 5;
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

// Bottom Navigation Bar
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
      }
      else if (index == 1){
        Navigator.pushNamed(context, '/chatbot');
      }
    },
  );
}