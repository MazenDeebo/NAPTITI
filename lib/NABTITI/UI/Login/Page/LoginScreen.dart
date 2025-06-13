import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nabtiti/NABTITI/UI/Login/Page/ForgetPassword.dart';
import '../../../../generated/l10n.dart';
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
  bool showPassword = true;


  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Widget _buildTextField(IconData icon, String hint, TextEditingController controller, {bool isPassword = false,bool show=false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        obscureText:hint==S().email?false:isPassword & show,

        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          icon: Icon(icon, color: const Color(0xFF063A23)),
          border: InputBorder.none,
          hintText: hint,
          suffixIcon:hint==S().email? null:IconButton(
            icon: Icon(
              isPassword & show ? Icons.visibility_off : Icons.visibility,
              color: const Color(0xFF063A23),
            ),
            onPressed: (){
              setState(() {
                showPassword = !showPassword;
              });
            },
          ),
        ),
        validator: (value) {
          if (hint==S().email){
            if (value!.isEmpty) {
              return PreferenceUtils.getString(prefKeys.language)=="en"?"Email Required":"يرجي إدخال الايميل";
            }
            if (!value.contains("@") || !value.contains(".")) {
              return PreferenceUtils.getString(prefKeys.language)=="en"?"Invalid Email":"البريد الإلكتروني غير صالح";
            }
          }
          else if(hint==S().password){
            if (value!.isEmpty) {
              return PreferenceUtils.getString(prefKeys.language)=="en"?"Password required":"يرجي إدخال كلمة المرور";
            }
            if (value.length < 5) {
              return PreferenceUtils.getString(prefKeys.language)=="en"?"Password must be at least 6 Characters":"يجب أن تتكون كلمة المرور من 6 أحرف او ارقام على الأقل";
            }
          }
          return null;
        },
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

  final formKey = GlobalKey<FormState>();

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
    if (!formKey.currentState!.validate()){
      return;
    }
    bool w=await checkInternetConnection();
    if (w){
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      try {
        QuerySnapshot userQuery = await FirebaseFirestore.instance
            .collection("USER")
            .where("Email", isEqualTo: email)
            .get();

        if (userQuery.docs.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(
                PreferenceUtils.getString(prefKeys.language)=="en"?
                "User does not exist!"
                    :
                "المستخدم غير موجود!"
            )),
          );
          return;
        }

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        ).then((value) {
          joinAsUser();

        });
        joinAsUser();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PostLoginSplashScreen())
        );
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

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildBackground(),
                Center(child: _buildLogo()),
                PreferenceUtils.getString(prefKeys.language)=="en"?
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
                )
                    :
                Positioned(
                  top: 40,
                  left: 330,
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
                )
              ],
            ),
          ),

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
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          Center(
                            child: Text(S().welcomeBack,
                                style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF063A23))),
                          ),
                          const SizedBox(height: 5),
                          Center(
                            child: Text(
                                PreferenceUtils.getString(prefKeys.language)=="en"?
                                "We’re so excited to see you again"
                                    :
                                "نحن متحمسون جدًا لرؤيتك مرة أخرى"
                                ,
                                style: GoogleFonts.poppins(color: Colors.black54)),
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(Icons.email, S().email, emailController),
                          _buildTextField(Icons.lock, S().password, passwordController, isPassword: true,show: showPassword),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: ()  {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ForgetPasswordSceen()),
                                );
                              },
                              child: Text(
                                PreferenceUtils.getString(prefKeys.language)=="en"?
                                "Forgot your password?"
                                    :
                                "نسيت كلمة المرور؟",
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xFF063A23),
                                      decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildButton(context, S().login, _login),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  PreferenceUtils.getString(prefKeys.language)=="en"?
                                  "Don’t have an account?"
                                      :
                                  "ليس لديك حساب؟"
                                  ,
                                  style: GoogleFonts.poppins(color: Colors.grey)),
                              TextButton(
                                onPressed: (){
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => RegisterScreen(fromLogin: true,))
                                  );
                                },
                                child: Text(S().register,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF063A23))),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                        ],
                      ),
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
Future<bool> checkInternetConnection() async{
  bool hasConnection = await InternetConnectionChecker.instance.hasConnection;
  return hasConnection;
}