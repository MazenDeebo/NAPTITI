import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../main.dart';
import '../../Register/Page/RegisterScreen.dart';


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


Widget _buildRegisterLink(BuildContext context) {
  return TextButton(
    onPressed: () => Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterScreen())),
    child: Text("Register", style: GoogleFonts.poppins(color: Colors.white)),
  );
}

