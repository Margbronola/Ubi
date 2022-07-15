// ignore_for_file: avoid_print

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:internapp/change_password.dart';
import 'package:internapp/global/access.dart';
import 'package:internapp/login_page.dart';
import 'package:internapp/menu_page.dart';
import 'package:internapp/profile_details.dart';
import 'package:internapp/services/API/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key,}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class SwitcherData {
  final int id;
  final Widget icon;
  final String title;
  bool isEnabled;
  final Function onPressed;
  SwitcherData(
      {required this.icon,
      required this.id,
      required this.title,
      this.isEnabled = false,
      required this.onPressed});
}

class ChildData {
  final Widget icon;
  final String title;
  final String? destination;
  final Function? onPressed;
  const ChildData(
      {required this.destination,
      required this.icon,
      required this.title,
      this.onPressed});
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;
  final Auth _auth = Auth();

  deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('accesstoken');
    print('token deleted');
  }

  displayToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? value = _prefs.getString("accesstoken");
    setState(() {});
    print(value);
  }

  Future<void> fetch() async {
    await _auth.getUserDetails().then((value) async {
      if (value != null) {
        setState(() {
          loggedUser = value;
        });
      }
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    await fetch();
  }

  Widget titledData({required List<ChildData> childrenData}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...childrenData.map(
            (e) => MaterialButton(
              onPressed: () {
                if (e.destination != null) {
                  Navigator.pushNamed(context, e.destination!);
                } else {
                  e.onPressed!();
                }
              },
              padding: const EdgeInsets.all(0),
              child: Container(
                height: 55,
                width: 500,
                color: Colors.grey.shade200,
                child: ListTile(
                  contentPadding: const EdgeInsets.only(left: 20, right: 20),
                  leading: e.icon,
                  title: Text(e.title),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Color.fromARGB(255, 15, 41, 142),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return DraggableScrollableSheet(
      minChildSize: .08,
      initialChildSize: .65,
      maxChildSize: .65,
      builder: (context, scrollController){
        return Container(
          padding: const EdgeInsets.only(top: 30),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50)
              ),
            ),

          child: ListView(
            controller: scrollController,
            children: [
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(left: 30, bottom: 10, right: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                    child: const Icon(Icons.person_rounded, size: 50, color: Colors.grey,),
                  ),
            
                  Expanded(
                    // height: 100,
                    // width: 250,
                    // margin: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(loggedUser?.name ?? "FETCHING DETAILS",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          )
                        ),
            
                        Text(loggedUser?.position ?? "FETCHING DETAILS",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 232, 149, 40)
                          )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color:Colors.grey.shade300, thickness: 3),
              ),

              Container(
                height: 400,
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                child: ListView(
                  children: [

                    titledData(
                      childrenData: [
                        ChildData(
                          icon: const Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 232, 149, 40),
                          ),
                          title: "Details",
                          destination: null,
                          onPressed: loggedUser == null ? null : () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              constraints: BoxConstraints(
                                maxHeight: size.height,
                              ),
                              context: context,
                              builder: (_) => BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY:5),
                                child: ProfileDetailsPage(callback: (bool s) {setState(() {});})
                              )
                            );
                          },
                        )
                      ],
                    ),

                    titledData(
                      childrenData: [
                        ChildData(
                          icon: const Icon(Icons.security_rounded,
                            color: Color.fromARGB(255, 232, 149, 40)
                          ),
                          title: "Change Password",
                          destination: null,
                          onPressed: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              constraints: BoxConstraints(
                                maxHeight: size.height,
                              ),
                              context: context,
                              builder: (_) => BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY:5),
                                child: const ChangePasswordPage()
                              )
                            );
                          },
                        )
                      ]
                    ),

                    titledData(
                      childrenData: [
                        ChildData(
                          icon: const Icon(Icons.menu_rounded,
                            color: Color.fromARGB(255, 232, 149, 40)
                          ),
                          title: "My Menu",
                          destination: null,
                          onPressed: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              constraints: BoxConstraints(
                                maxHeight: size.height,
                              ),
                              context: context,
                              builder: (_) => BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY:5),
                                child: const MenuPage()
                              )
                            );
                          },
                        )
                      ]
                    ),

                    Container(
                      width: 600,
                      height: 55,
                      margin: const EdgeInsets.only(top: 40, bottom: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });

                          await _auth.logout().then((value) {
                            if (value) {
                              displayToken();
                              deleteToken();
                              Navigator.pushReplacement(
                                context, MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            }
                          }).whenComplete(
                            () => setState(
                              () => isLoading = false,
                            ),
                          );
                        },
                        
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          primary:const Color.fromARGB(255, 40, 84, 232)
                        ),
                        child: const Text('LOGOUT',
                          style: TextStyle(
                            fontSize: 20, 
                            letterSpacing: 3
                          ),
                        ),
                      ),
                    ),
                  ]
                )
              )
            ]
          )
        );
      }
    );
  }
}