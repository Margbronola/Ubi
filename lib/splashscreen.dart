import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internapp/global/access.dart';
import 'package:internapp/services/API/datacacher.dart';
import 'package:internapp/viewmodel/navigationbuttonviewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final DataCacher _dataCacher = DataCacher.instance;
  final NavigationButtonViewModel _menuViewModel = NavigationButtonViewModel.instance;

  checkMenu() async {
    _menuViewModel.populate(_dataCacher.menuList);
  }

  @override
  void initState(){
    checker();
    super.initState();
  }

  checker() async{
    String? d  = _dataCacher.uToken;

    if(d == null){
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pushNamed(context, '/login_page');
    }
    
    else{
      setState(() {
        accessToken = d;
      });
      checkMenu();
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushNamed(context, '/landing_page');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      color: Colors.white,
      width: size.width,
      height: size.height,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 130,
              height: 100,
              margin: const EdgeInsets.only(bottom: 15),
              child: Image.asset('assets/images/BlackLogo.png', fit: BoxFit.fitWidth)
            ),
            
            const CircularProgressIndicator(
              strokeWidth: 6,
            ),
          ]
        ),
      ),
    );
  }
}