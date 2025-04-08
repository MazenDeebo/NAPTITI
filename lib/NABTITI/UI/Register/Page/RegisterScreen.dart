import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../main.dart';
import '../../Login/Page/LoginScreen.dart';

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
