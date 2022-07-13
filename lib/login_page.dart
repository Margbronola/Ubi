// ignore_for_file: avoid_print, deprecated_member_use, dead_code

import 'package:flutter/material.dart';
import 'package:internapp/forget_password_page.dart';
import 'package:internapp/landing_page.dart';
import 'package:internapp/services/API/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, this.isFromAlertBox = 0.08}) : super(key: key);
  final double isFromAlertBox;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool isLoading = false;
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Form(
          key: _formkey,
          child: Stack(
            children: [
              Container(
                constraints: const BoxConstraints.expand(),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bgImage.jpg"),
                    fit: BoxFit.cover
                  )
                )
              ),
          
              Center(
                child: SizedBox(
                  width: 190,
                  height: 190,
                  child: Image.asset("assets/images/WhiteLogo.png",)
                )
              ),
          
              DraggableScrollableSheet(
                minChildSize: .08,
                initialChildSize: widget.isFromAlertBox,
                maxChildSize: .5,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)
                      ),
                    ),
                    
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      controller: scrollController,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(40, 70, 40, 0),
                          alignment: Alignment.centerLeft,
                          child: const Text('LOGIN', 
                            style: TextStyle(
                              fontSize: 22,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
          
                        Container(
                          height: 55,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0,5),
                                blurRadius: 10,
                                color: Colors.grey.shade400
                              )
                            ]
                          ),
                          margin: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter your Email';
                              }
          
                              if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                                return 'Please enter a valid Email';
                              }
          
                              return null;
                            },
                            style: const TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white) 
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              prefixIcon: const Icon(Icons.person, color: Color.fromARGB(255, 232, 149, 40)),
                              hintText: 'Username',
                              suffixIcon: IconButton(
                                color: Colors.grey.shade400,
                                icon: const Icon(Icons.close_rounded),
                                onPressed: () {
                                  _emailController.clear();
                                }
                              )
                            ),
                          ),
                        ),
          
                        Container(
                          height: 55,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0,5),
                                blurRadius: 10,
                                color: Colors.grey.shade400
                              )
                            ]
                          ),
                          margin: const EdgeInsets.fromLTRB(40, 15, 40, 0),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: _isObscure,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter your Password';
                              }
                              return null;
                            },
                            style: const TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              enabledBorder: const  OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white) 
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              prefixIcon: const Icon(Icons.key_rounded, color: Color.fromARGB(255, 232, 149, 40)),
                              hintText: 'Password',
                              suffixIcon: IconButton(
                                color: Colors.grey.shade400,
                                icon: Icon(_isObscure
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                }
                              )
                            ),
                          ),
                        ),
                    
                        Container(
                          margin: const EdgeInsets.only(top: 40),
                          width: 500,
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:BorderRadius.circular(10)
                              ),
                              primary: const Color.fromARGB(255, 40, 84, 232)
                            ),
                            child: const Text('LOGIN',
                              style: TextStyle(fontSize: 20, letterSpacing: 3),
                            ),
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
          
                                print("LOGGING IN");
                                await _auth.login(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                ).then((value) {
                                  if (value) {
                                    Navigator.pushReplacement(
                                      context,  MaterialPageRoute(
                                        builder: (context) => const LandingPage(),
                                      ),
                                    );
                                  } 
          
                                  else {
                                    return showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25)
                                          ),
                                        title: const Text("Access Denied",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18
                                          )
                                        ),
          
                                        content: const Text("Incorrect email/password", textAlign: TextAlign.center),
        
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            child: const Text("Close"),
                                          )
                                        ]
                                      ),
                                    );
                                    print("Incorrect Password");
                                  }
                                }).whenComplete(
                                  () => setState(
                                    () => isLoading = false,
                                  ),
                                );
                              } else {
                                print('Unsuccessful');
                              }
                            },
                          ),
                        ),
          
                        Container(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                          child: TextButton(
                            child: const Text('Forget Password?',
                              style: TextStyle(
                                fontSize: 18, 
                                color: Colors.black
                              )
                            ),
                            onPressed: () {
                              Navigator.push(
                                context, MaterialPageRoute(
                                  builder: (context) =>
                                  const ForgetPasswordPage()
                                )
                              );
                            },
                          ),
                        ),         
                      ]
                    ),
                  );
                }
              ),
              isLoading ? Container(
                color: Colors.black38,
                width: size.width,
                height: size.height,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ): Container()
            ]
          ),
        ),    
      ),
    );
  }
}