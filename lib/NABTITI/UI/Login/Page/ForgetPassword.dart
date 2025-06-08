import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../generated/l10n.dart';
import '../../../shared.dart';

class ForgetPasswordSceen extends StatefulWidget {
  const ForgetPasswordSceen({super.key});

  @override
  State<ForgetPasswordSceen> createState() => _ForgetPasswordSceenState();
}

class _ForgetPasswordSceenState extends State<ForgetPasswordSceen> {
  final emailController=TextEditingController();
  final formKey=GlobalKey<FormState>();

  void enterCode(){
    if(!formKey.currentState!.validate()){
      return;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios,color: Colors.black,)),
        title:Text(
            PreferenceUtils.getString(prefKeys.language)=="en"?
            "Forgot your password?"
                :
            "نسيت كلمة المرور؟",
            style: TextStyle(color: Color(0xFF063A23))),
        centerTitle: true,
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller:emailController ,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration:  InputDecoration(
                  labelText: S().email,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return PreferenceUtils.getString(prefKeys.language)=="en"?"Email Required":"يرجي إدخال الايميل";
                  }
                  if(!value.contains("@") || !value.contains(".")){
                    return PreferenceUtils.getString(prefKeys.language)=="en"?"Invalid Email":"البريد الإلكتروني غير صالح";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20,),

              ElevatedButton(
                onPressed: ()async{
                  enterCode();
                  String email=emailController.text;
                  if (email.isNotEmpty) {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: email).then((value){}).catchError((error){});
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF063A23),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(S().send, style: GoogleFonts.poppins(fontSize: 16)),
              )
            ],
          ),
        ),
      ),

    );
  }
}
