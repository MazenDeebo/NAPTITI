import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui' as ui;
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/upload': (context) => UploadImageScreen(),
        '/home': (context) => PlantSelectionScreen(),
      },
    );
  }
}

// 🔹 SPLASH SCREEN WITH ANIMATION
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  double _scale = 0.8;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1100), () {
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
      });
    });

    Timer(const Duration(seconds: 7), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RegisterScreen()),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/bg_login.png', fit: BoxFit.cover),
          Center(
            child: AnimatedOpacity(
              duration: const Duration(seconds: 5),
              opacity: _opacity,
              child: AnimatedScale(
                scale: _scale,
                duration: const Duration(seconds: 5),
                curve: Curves.easeOutBack,
                child: Image.asset('assets/logo.png', width: 200, height: 200),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 REGISTER SCREEN
class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();

  Future<void> _register() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String repeatPassword = repeatPasswordController.text.trim();

    if (password != repeatPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match!")),
      );
      return;
    }

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance.collection("USER").doc(userCredential.user!.uid).set({
        "Email": email,
        "Password": password,
        "RegistrationDate": Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration Successful!")),
      );

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => PostRegisterScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildLogo(),
                  Text("Hi!",
                      style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Text("Register yourself with us",
                      style: GoogleFonts.poppins(color: Colors.white)),
                  const SizedBox(height: 20),
                  _buildTextField(Icons.email, "Email", emailController),
                  _buildTextField(Icons.lock, "Password", passwordController,
                      isPassword: true),
                  _buildTextField(Icons.lock, "Repeat your password",
                      repeatPasswordController, isPassword: true),
                  const SizedBox(height: 20),
                  _buildButton(context, "Sign Up", _register),
                  _buildLoginLink(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 LOGIN SCREEN
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection("USER")
          .where("Email", isEqualTo: email)
          .get();

      if (userQuery.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User does not exist!")),
        );
        return;
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Successful!")),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => PostLoginSplashScreen()));
      // Navigate to home screen (Replace with your screen)
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildLogo(),
                  Text("!مرحبا بك",
                      style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Text("We're so excited to see you again",
                      style: GoogleFonts.poppins(color: Colors.white)),
                  const SizedBox(height: 20),
                  _buildTextField(Icons.email, "Email", emailController),
                  _buildTextField(Icons.lock, "Password", passwordController,
                      isPassword: true),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: TextButton(
                        onPressed: () {},
                        child: Text("Forgot your password?",
                            style: GoogleFonts.poppins(color: Colors.white)),
                      ),
                    ),
                  ),
                  _buildButton(context, "Login", _login),
                  _buildRegisterLink(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 COMMON WIDGETS
Widget _buildTextField(IconData icon, String hint,
    TextEditingController controller,
    {bool isPassword = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
    child: TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black54),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    ),
  );
}

Widget _buildButton(BuildContext context, String text, VoidCallback onPressed) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24.0),
    child: SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF063A23),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(text,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 18)),
      ),
    ),
  );
}

Widget _buildBackground() {
  return Container(
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/bg_login.png'),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget _buildLogo() {
  return Column(
    children: [
      const SizedBox(height: 40),
      Image.asset('assets/logo.png', width: 200, height: 200),
      const SizedBox(height: 10),
    ],
  );
}

Widget _buildLoginLink(BuildContext context) {
  return TextButton(
    onPressed: () => Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen())),
    child: Text("Login", style: GoogleFonts.poppins(color: Colors.white)),
  );
}

Widget _buildRegisterLink(BuildContext context) {
  return TextButton(
    onPressed: () => Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterScreen())),
    child: Text("Register", style: GoogleFonts.poppins(color: Colors.white)),
  );
}

// post register
class PostRegisterScreen extends StatefulWidget {
  @override
  _PostRegisterScreenState createState() => _PostRegisterScreenState();
}

class _PostRegisterScreenState extends State<PostRegisterScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_after.png'), // Ensure this exists
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', width: 100), // Ensure this exists
              SizedBox(height: 20),
              Text(
                "Thanks for joining us!",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(color: Colors.white), // Ensure visibility
            ],
          ),
        ),
      ),
    );
  }
}



// post login
class PostLoginSplashScreen extends StatefulWidget {
  @override
  _PostLoginSplashScreenState createState() => _PostLoginSplashScreenState();
}

class _PostLoginSplashScreenState extends State<PostLoginSplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PlantSelectionScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_after.png'), // Ensure this exists
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', width: 100), // Ensure this exists
              SizedBox(height: 20),
              Text(
                "Hi! Welcome back",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(color: Colors.white), // Ensure visibility
            ],
          ),
        ),
      ),
    );
  }
}



// 🔹 PLANT SELECTION SCREEN
class PlantSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      BottomNavigationBarItem(icon: Icon(Icons.info), label: "Info"),
    ],
    onTap: (index) {
      if (index == 0) {
        Navigator.pushNamed(context, '/home');
      }
    },
  );
}

// List of Plants
final List<Map<String, String>> plantList = [
  {"name": "Tomato", "image": "assets/tomato.png"},
  {"name": "Potato", "image": "assets/potato.png"},
  {"name": "Corn", "image": "assets/corn.png"},
];



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
                    // Implement approval logic
                  },
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

