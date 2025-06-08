import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nabtiti/NABTITI/UI/Landing/page/landing.dart';

import '../../../../generated/l10n.dart';
import '../../../../main.dart';
import '../../../shared.dart';
import '../../Login/Page/LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen( {super.key, this.fromLogin=false});
  final bool fromLogin;


  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();

  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
  }

  bool showPassword = false;
  final formKey = GlobalKey<FormState>();
  Future<void> _register() async {
    if (!formKey.currentState!.validate()){
      return;
    }
    bool w = await checkInternetConnection();
    if(w){
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      String repeatPassword = repeatPasswordController.text.trim();

      if (password != repeatPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(
              PreferenceUtils.getString(prefKeys.language)=="en"?
              "Passwords do not match!"
                  :
              "كلمات المرور غير متطابقة!"
          )),
        );
        return;
      }
      try{
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
            SnackBar(content: Text(
                PreferenceUtils.getString(prefKeys.language)=="en"?
                "Registration Successful!"
                    :
                "تم التسجيل بنجاح!"
            )),
          );

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => PostRegisterScreen()));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $e")),
          );
        }

    }
    else{
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

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _backButton(context),
                    Image.asset('assets/logo.png',color: Color(0xFF063A23), height: 50),
                  ],
                ),
                const SizedBox(height: 40),
                Text(S().hi,
                    style: GoogleFonts.poppins(
                        fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF063A23))),
                const SizedBox(height: 8),
                Text(
                    PreferenceUtils.getString(prefKeys.language)=="en"?
                    "Register yourself with us"
                        :
                    "سجل معنا"
                    ,
                    style: GoogleFonts.poppins(fontSize: 16, color: Color(0xFF063A23))),
                const SizedBox(height: 40),
                _buildTextField(Icons.email_outlined, S().email, emailController),
                _buildPasswordField(passwordController, S().password, showPassword, () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                }),
                _buildPasswordField(repeatPasswordController, S().repeatPassword, showPassword, () {
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
                    Text(
                        PreferenceUtils.getString(prefKeys.language)=="en"?
                        "Already have an account?"
                            :
                        "لديك حساب بالفعل؟"
                        ,
                        style: GoogleFonts.poppins(color: Colors.grey)),
                    TextButton(
                      onPressed: () => Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginScreen())),
                      child: Text(S().login,
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
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.fromLogin?
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginScreen()))
            :
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LandingScreen()));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: const Color(0xFF063A23),
            borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white),
          filled: true,
          fillColor: Color(0xFF063A23),
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.white),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),

        ),
        validator: (value) {
            if (value!.isEmpty) {
              return PreferenceUtils.getString(prefKeys.language)=="en"?"Email Required":"يرجي إدخال الايميل";
            }
            if (!value.contains("@") || !value.contains(".")) {
              return PreferenceUtils.getString(prefKeys.language)=="en"?"Invalid Email":"البريد الإلكتروني غير صالح";
            }
            return null;
          },
        style: GoogleFonts.poppins(color: Colors.white),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hint, bool isVisible, VoidCallback toggleVisibility) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
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
        validator: (value) {
          if (value!.isEmpty) {
            return PreferenceUtils.getString(prefKeys.language)=="en"?"Password required":"يرجي إدخال كلمة المرور";
          }
          if (value.length < 5) {
            return PreferenceUtils.getString(prefKeys.language)=="en"?"Password must be at least 6 Characters":"يجب أن تتكون كلمة المرور من 6 أحرف او ارقام على الأقل";
          }
          return null;
        },
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
        child: Text(
            S().signUp,
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
Future<bool> checkInternetConnection() async{
  bool hasConnection = await InternetConnectionChecker.instance.hasConnection;
  return hasConnection;
}