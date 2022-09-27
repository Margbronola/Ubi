// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:internapp/login_page.dart';
import 'package:flutter/gestures.dart';
import 'package:internapp/services/API/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentpassword = TextEditingController();
  final TextEditingController _newpassword = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool isLoading = false;
  final Auth _auth = Auth();

  final bool _isObscure = true;
  final bool _isObscure1 = true;
  final bool _isObscure2 = true;

  deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('accesstoken');
    print('token deleted');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DraggableScrollableSheet(
          minChildSize: .5,
          initialChildSize: .8,
          maxChildSize: 1,
          builder: (context, scrollController){
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50)
                ),
              ),
              child: Form(
                key: _formkey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  shrinkWrap: true ,
                  controller: scrollController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 10),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 25, bottom: 10),
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade200,
                            ),
                            child: Icon(Icons.key_rounded, size: 40, color: Colors.orange.shade600),
                          ),
                      
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: const Text('CHANGE PASSWORD', 
                              style: TextStyle(
                                fontSize: 20,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                      
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(color:Colors.grey.shade300, thickness: 3),
                    ),
                
                    const Padding(
                      padding: EdgeInsets.fromLTRB(50, 30, 50, 5),
                      child: Text(
                        'Current Password',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0,3),
                            blurRadius: 7,
                            color: Colors.grey.shade400
                          )
                        ]
                      ),
                      margin: const EdgeInsets.only(top: 5, right: 50, left: 50),
                      child: TextFormField(
                        controller: _currentpassword,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your Password';
                          }
                          return null;
                        },
                          obscureText: _isObscure,
                          style: const TextStyle(fontSize: 15),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white) 
                              ),
                              fillColor: Colors.white,
                              filled: true,
                          //   suffixIcon: IconButton(
                          //     color: Colors.grey,
                          //     icon: Icon(_isObscure
                          //       ? Icons.visibility_off_rounded
                          //       : Icons.visibility),
                          //     onPressed: () {
                          //       setState(() {
                          //         _isObscure = !_isObscure;
                          //     });
                          //   }
                          // )
                        ),
                      ),
                    ),
                
                    const Padding(
                      padding: EdgeInsets.fromLTRB(50, 30, 50, 5),
                      child: Text(
                        'New Password',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0,3),
                            blurRadius: 7,
                            color: Colors.grey.shade400
                          )
                        ]
                      ),
                      margin: const EdgeInsets.only(top: 5, right: 50, left: 50),
                      child: TextFormField(
                        controller: _newpassword,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your New Password';
                          }
                          return null;
                        },
                        obscureText: _isObscure1,
                        style: const TextStyle(fontSize: 15),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        enabledBorder:  OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white) 
                          ),
                              fillColor: Colors.white,
                              filled: true,
                          // suffixIcon: IconButton(
                          //   color: Colors.grey,
                          //   icon: Icon(_isObscure1
                          //     ? Icons.visibility_off_rounded
                          //     : Icons.visibility),
                          //   onPressed: () {
                          //     setState(() {
                          //       _isObscure1 = !_isObscure1;
                          //     });
                          //   }
                          // )
                        ),
                      ),
                    ),
                
                    const Padding(
                      padding: EdgeInsets.fromLTRB(50, 30, 50, 5),
                      child: Text('Confirm New Password',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0,3),
                            blurRadius: 7,
                            color: Colors.grey.shade400
                          )
                        ]
                      ),
                      margin: const EdgeInsets.only(top: 5, right: 50, left: 50),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _confirmpassword,
                        validator: (value) {
                          if (_newpassword.text.isEmpty) {
                            if (value!.isEmpty) {
                              return null;
                            }
                          } 
                          else {
                            if (value!.isEmpty) {
                              return 'Retype Password';
                            }
                          }

                          if (_newpassword.text != _confirmpassword.text) {
                            return 'Password didn\'t match';
                          }
                          return null;
                        },
                        
                        obscureText: _isObscure2,
                        style: const TextStyle(fontSize: 15),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        enabledBorder:  OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white) 
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          // suffixIcon: IconButton(
                          //   color: Colors.grey,
                          //   icon: Icon(_isObscure2
                          //     ? Icons.visibility_off_rounded
                          //     : Icons.visibility),
                          //   onPressed: () {
                          //     setState(() {
                          //       _isObscure2 = !_isObscure2;
                          //     });
                          //   }
                          // )
                        ),
                      ),
                    ),
                
                    FocusScope.of(context).hasFocus != true ?
                    Container(
                      margin: const EdgeInsets.only(top: 40, bottom: 0),
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                          primary: const Color.fromARGB(255, 40, 84, 232)),
                        child: const Text('SAVE',
                          style: TextStyle(
                            fontSize: 20, 
                            letterSpacing: 3
                          ),
                        ),
                        onPressed: () async{
                          if (_formkey.currentState!.validate()) {
    
                            setState(() {
                                isLoading = true;
                              });
    
                            final String oldPass = _currentpassword.text;
                            final String newPass = _newpassword.text;
                            final String confirmPass = _confirmpassword.text;
    
                            await _auth.changePassword(oldPass, newPass, confirmPass)
                              .then((value) async {
                                if(value!){
                                  print('Successful');
                                
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)
                                      ),
                                      content: SizedBox(
                                        width: 300,
                                        height: 150,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(vertical: 20),
                                              child: Icon(Icons.check_circle_rounded, color: Colors.green, size: 30),
                                            ),
                                            const Text('Password Successfully Changed!', 
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20
                                              ),
                                            ),
                                            RichText(
                                            text: TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: "Use your new password to ",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17
                                                  ),
                                                ),
    
                                                TextSpan(
                                                  text: "Login",
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 17
                                                  ),
                                                  recognizer: TapGestureRecognizer()..onTap = () {
                                                    deleteToken();
                                                    Navigator.pushReplacement(
                                                      context, MaterialPageRoute(
                                                        builder: (context) => const LoginPage(isFromAlertBox: 0.5,)
                                                      )
                                                    );
                                                  }
                                                ),
                                              ]
                                            )
                                          ),
                                        ],  
                                      ),
                                    )
                                  ),
                                );
                              }
    
                              else{
                                return showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)
                                    ),
                                    title: const Text("Error",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20
                                      )
                                    ),
                                    content: const Text("Incorrect old password"),
                                    actions: <Widget>[
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: const Text("Close"),
                                      )
                                    ]
                                  ),
                                );
                              }
    
                            }).whenComplete(
                              () => setState(
                                () => isLoading = false,
                              ),
                            );
                          } 
                
                          else {
                            print('Unsuccessful');
                          }
                        },
                      ),
                    ) : Container(
                      margin: const EdgeInsets.only(top: 40, bottom: 280),
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                          primary: const Color.fromARGB(255, 40, 84, 232)),
                        child: const Text('SAVE',
                          style: TextStyle(
                            fontSize: 20, 
                            letterSpacing: 3
                          ),
                        ),
                        onPressed: () async{
                          if (_formkey.currentState!.validate()) {
    
                            setState(() {
                                isLoading = true;
                              });
    
                            final String oldPass = _currentpassword.text;
                            final String newPass = _newpassword.text;
                            final String confirmPass = _confirmpassword.text;
    
                            await _auth.changePassword(oldPass, newPass, confirmPass)
                              .then((value) async {
                                if(value!){
                                  print('Successful');
                                
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)
                                      ),
                                      content: SizedBox(
                                        width: 300,
                                        height: 150,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(vertical: 20),
                                              child: Icon(Icons.check_circle_rounded, color: Colors.green, size: 30),
                                            ),
                                            const Text('Password Successfully Changed!', 
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20
                                              ),
                                            ),
                                            RichText(
                                            text: TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: "Use your new password to ",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17
                                                  ),
                                                ),
    
                                                TextSpan(
                                                  text: "Login",
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 17
                                                  ),
                                                  recognizer: TapGestureRecognizer()..onTap = () {
                                                    deleteToken();
                                                    Navigator.pushReplacement(
                                                      context, MaterialPageRoute(
                                                        builder: (context) => const LoginPage(isFromAlertBox: 0.5,)
                                                      )
                                                    );
                                                  }
                                                ),
                                              ]
                                            )
                                          ),
                                        ],  
                                      ),
                                    )
                                  ),
                                );
                              }
    
                              else{
                                return showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)
                                    ),
                                    title: const Text("Error",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20
                                      )
                                    ),
                                    content: const Text("Incorrect old password", textAlign: TextAlign.center),
                                    actions: <Widget>[
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: const Text("Close"),
                                      )
                                    ]
                                  ),
                                );
                              }
    
                            }).whenComplete(
                              () => setState(
                                () => isLoading = false,
                              ),
                            );
                          } 
                
                          else {
                            print('Unsuccessful');
                          }
                        },
                      ),
                    )
                
                  ]
                ),
              )
            );
          }
      ),
    );
  }
}