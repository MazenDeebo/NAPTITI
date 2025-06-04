import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared.dart';
import '../../Home/Page/Home.dart';
import '../../Login/Page/LoginScreen.dart';
import '../../Register/Page/RegisterScreen.dart';
class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});
  @override
  State<LandingScreen> createState() => _LandingScreenState();
}
void joinAsGuest() async{
  PreferenceUtils.setBool(prefKeys.loggedIn,false);
}

class _LandingScreenState extends State<LandingScreen> {

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
                  Text("A Step Towards\nLess Plants \nDisease.",
                      style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 20),

                  //_buildButton(context, "Login", _login),
                  Container(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.withOpacity(0.5),
                          shadowColor: Colors.transparent
                      ),
                      child: Text('Login',style: TextStyle(color: Colors.white),),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  _buildRegisterLink(context),
                  SizedBox(height: 20,),
                  TextButton(
                    onPressed: () {
                      //joining as guest
                      joinAsGuest();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context)=> Home()
                          )
                      );
                    },
                    child: Text("Continuo as a guest ", style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w700)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
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
      Image.asset('assets/logo.png', width: 400, height: 250),
      const SizedBox(height: 10),
    ],
  );
}


Widget _buildRegisterLink(BuildContext context) {
  return TextButton(
    onPressed: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RegisterScreen())
    ),
    child: Text("Don't have an account ? Sign Up", style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w700)),
  );
}

