import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nabtiti/NABTITI/UI/Login/Page/ForgetPassword.dart';

import '../../../../main.dart';
import '../../../shared.dart';
import '../../Landing/page/landing.dart';
import '../../Register/Page/RegisterScreen.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Widget _buildTextField(IconData icon, String hint, TextEditingController controller, {bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          icon: Icon(icon, color: const Color(0xFF063A23)),
          border: InputBorder.none,
          hintText: hint,
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF063A23),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(text, style: GoogleFonts.poppins(fontSize: 16)),
    );
  }

  Widget _buildLogo() {
    return Image.asset('assets/logo.png', width: 500);
  }

  Widget _buildBackground() {
    return Image.asset(
      'assets/bg_login.png',
      fit: BoxFit.cover,
    );
  }

  void joinAsGuest() async{
    PreferenceUtils.setBool(prefKeys.loggedIn,false);
  }

  void joinAsUser() async{
    PreferenceUtils.setBool(prefKeys.loggedIn,true);
  }

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
      ).then((value) {
        joinAsUser();

      });


      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PostLoginSplashScreen())
      );
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
      body: Column(
        children: [
          // Top Half with background and logo
          Expanded(
            flex: 2,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildBackground(),
                Center(child: _buildLogo()),
                Positioned(
                  top: 40,
                  left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) =>  LandingScreen()),
                        );
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Color(0xFF063A23)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Half (White Card)
          Expanded(
            flex: 3,
            child:
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    'assets/bg_login.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  height: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(40) //
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Text("Welcome Back!",
                              style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF063A23))),
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: Text("We’re so excited to see you again",
                              style: GoogleFonts.poppins(color: Colors.black54)),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(Icons.email, "E-mail", emailController),
                        _buildTextField(Icons.lock, "Password", passwordController, isPassword: true),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ForgetPasswordSceen()),
                              );
                            },
                            child: Text("Forgot your password?",
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF063A23),
                                    decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildButton(context, "Login", _login),
                        const SizedBox(height: 10),
                        Center(
                          child: Text.rich(
                            TextSpan(
                              text: "Don’t have an account? ",
                              style: GoogleFonts.poppins(color: Colors.grey),
                              children: [
                                TextSpan(
                                  text: "Register",
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF063A23),
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                                      );
                                    },
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                      ],
                    ),
                  ),
                )
              ]
            ),

          ),
        ],
      ),
    );
  }
}
