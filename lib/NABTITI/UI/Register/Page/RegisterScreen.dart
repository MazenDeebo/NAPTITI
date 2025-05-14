import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nabtiti/NABTITI/UI/Landing/page/landing.dart';

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

  bool showPassword = false;
  bool showRepeatPassword = false;

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

      await FirebaseFirestore.instance
          .collection("USER")
          .doc(userCredential.user!.uid)
          .set({
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
      backgroundColor: const Color(0xFFFAF9F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _backButton(context),
                  Image.asset('assets/logo.png', height: 90,width: 120,color: Colors.black,),
                ],
              ),
              const SizedBox(height: 40),
              Text("Hi!",
                  style: GoogleFonts.poppins(
                      fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF063A23))),
              const SizedBox(height: 8),
              Text("Register yourself with us",
                  style: GoogleFonts.poppins(fontSize: 16, color: Color(0xFF063A23))),
              const SizedBox(height: 40),
              _buildTextField(Icons.email_outlined, "E-mail", emailController),
              _buildPasswordField(passwordController, "Password", showPassword, () {
                setState(() {
                  showPassword = !showPassword;
                });
              }),
              _buildPasswordField(repeatPasswordController, "Repeat your password",
                  showPassword, () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  }),
              const SizedBox(height: 20),
              _buildSignUpButton(),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account ?",
                      style: GoogleFonts.poppins(color: Colors.grey)),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen())),
                    child: Text("Login",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF063A23))),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => LandingScreen())),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: const Color(0xFF063A23),
            borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
      ),
    );
  }

  Widget _buildTextField(
      IconData icon, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white),
          filled: true,
          fillColor: Color(0xFF063A23),
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.white),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
        style: GoogleFonts.poppins(color: Colors.white),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hint,
      bool isVisible, VoidCallback toggleVisibility) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key, color: Colors.white),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
            ),
            onPressed: toggleVisibility,
          ),
          filled: true,
          fillColor: Color(0xFF063A23),
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.white),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
        style: GoogleFonts.poppins(color: Colors.white),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _register,
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF063A23),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
        child: Text("Sign Up",
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
