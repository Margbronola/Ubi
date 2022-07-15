import 'package:flutter/material.dart';
import 'package:internapp/change_password.dart';
import 'package:internapp/landing_page.dart';
import 'package:internapp/login_page.dart';
import 'package:internapp/menu.dart';
import 'package:internapp/profile_details.dart';
import 'package:internapp/services/API/datacacher.dart';
import 'package:internapp/splashscreen.dart';
import 'package:internapp/takeorderpage.dart';
import 'package:page_transition/page_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final DataCacher _cacher = DataCacher.instance;
  await _cacher.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UBi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: const SplashScreen(),

      onGenerateRoute: (settings){
        switch(settings.name){
          case "/login_page":
          return PageTransition(child: const LoginPage(), type: PageTransitionType.leftToRightWithFade);    

          case "/profile_details_page":
            return PageTransition(child: ProfileDetailsPage(
              callback:(s){}), type: PageTransitionType.leftToRightWithFade);

          case "/change_password_page":
            return PageTransition(child: const ChangePasswordPage(), type: PageTransitionType.leftToRightWithFade);

          case "/menu":
            return PageTransition(child: const Menu(), type: PageTransitionType.leftToRightWithFade);
            
          case "/takeOrder":
            return PageTransition(child: const TakeOrderPage(), type: PageTransitionType.leftToRightWithFade);
          
          default:
            return PageTransition(child: const LandingPage(), type: PageTransitionType.fade);
        }
      },
    );
  }
}