import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../generated/l10n.dart';
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
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          Center(
            child:_isLoading?
            const CircularProgressIndicator(color: Colors.white)
                :
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildLogo(),
                  Text(PreferenceUtils.getString(prefKeys.language)=="en"?
                      "A Step Towards\nLess Plants \nDisease."
                          :
                      "خطوة\nلتقليل الامراض \nالنباتيه",
                      style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 20),

                  Container(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.withOpacity(0.5),
                          shadowColor: Colors.transparent
                      ),
                      child: Text(S().login,style: TextStyle(color: Colors.white),),
                      onPressed: (){
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
                    onPressed: () async {
                      setState(() => _isLoading = true); // Start loading
                      joinAsGuest();
                      bool w = await checkInternetConnection();
                      setState(() => _isLoading = false); // Stop loading
                      if (w) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(S().connectionMessage),
                            backgroundColor: const Color(0xFF063A23),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            margin: const EdgeInsets.all(20),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                    child: Text(S().guestMessage,
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
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
    onPressed: ()  {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RegisterScreen())
      );
    },
    child: Text(S().registerMessage, style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w700)),
  );
}

Future<bool> checkInternetConnection() async{
  bool hasConnection = await InternetConnectionChecker.instance.hasConnection;
  return hasConnection;
}