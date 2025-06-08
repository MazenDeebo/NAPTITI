import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../generated/l10n.dart';
import '../../../manager/app_cubit.dart';
import '../../../shared.dart';
import '../../Home/Page/Home.dart';
import '../../Landing/page/landing.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}
void saveLogout() async{
  PreferenceUtils.setBool(prefKeys.loggedIn,false);
}
class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(S().setting),
        elevation: 0,
        leading: IconButton(
            onPressed: (){
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home()
                  )
              );
            },
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black)),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              settingItem(
                onTap: (){
                  showChangeLanguageBottomSheet();
                },
                icon: Icons.language_rounded,
                title: S().language,
                value: PreferenceUtils.getString(prefKeys.language,'ar'),
              ),
              settingItem(
                onTap: (){
                  saveLogout();
                  FirebaseAuth.instance.signOut();
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context)=> LandingScreen())
                  );
                },
                icon: Icons.logout,
                title: PreferenceUtils.getBool(prefKeys.loggedIn)?S().logout:S().exit,
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget settingItem({
    required GestureTapCallback? onTap,
    required IconData icon,
    required String title,
    String value='',
  }){
    return InkWell(
      onTap:onTap,
      child: Container(
        color: Colors.white,
        margin:  EdgeInsets.symmetric(vertical: 10),
        padding:  EdgeInsets.all(15),
        child: Row(
          children: [
            Icon(icon,
              color:icon ==Icons.logout? Colors.red: Color(0xFF063A23),
            ),
            SizedBox(width: 5,),
            Text(title,
              style: TextStyle(
                  fontSize: 18
              ),
            ),
            const Spacer(),
            Text(value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 5,),
            const Icon(Icons.keyboard_arrow_right_rounded),
          ],
        ),
      ),
    );
  }

  showChangeLanguageBottomSheet(){
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context){
          return Container(
            height: 160,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25)
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  Text(
                    "${S().select} ${S().language}",
                    style: TextStyle(
                        fontSize:25
                    ),
                  ),
                  const SizedBox(height: 15,),
                  InkWell(
                    onTap: (){
                      PreferenceUtils.setString(prefKeys.language,'ar');
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding:const EdgeInsets.all(10),
                      child: Text(
                        S().arabic,
                        style: TextStyle(
                          fontSize:20
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      PreferenceUtils.setString(prefKeys.language,'en');
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding:const EdgeInsets.all(10),
                      child: Text(
                        S().english,
                        style: TextStyle(
                            fontSize:20
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ) ;
        }
    ).then((value) {
      BlocProvider.of<AppCubit>(context).settingChanged();
    });

  }


}
