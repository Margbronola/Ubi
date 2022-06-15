// ignore_for_file: avoid_print

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:internapp/login_page.dart';
import 'package:internapp/services/API/forgotpasswordApi.dart';

// ignore: use_key_in_widget_constructors
class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({ Key? key, this.email=""}) : super(key: key);

final String email;

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _retypepassword = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final ForgotPassApi _forgotPassApi = ForgotPassApi();
  bool isLoading = false;
  final bool _isObscure = true;
  final bool _isObscure1 = true;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
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
              minChildSize: .1,
              initialChildSize: .55,
              maxChildSize: .55,
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
                    controller: scrollController,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                        child: const Text('NEW PASSWORD', 
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            letterSpacing: 3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.fromLTRB(40,8,40,0),
                        child: Text('Enter your new password',
                          style: TextStyle(
                            color: Colors.black, 
                            fontSize: 20,
                            letterSpacing: 1
                          ),
                          textAlign: TextAlign.center
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.fromLTRB(40, 50, 40, 0),
                        child: TextFormField(
                          controller: _password,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) 
                            {
                              return 'Enter a Password';
                            }
                            return null;
                          },
              
                        obscureText: _isObscure,
                          style: const TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(255, 40, 84, 232)) 
                          ),
                            fillColor: Colors.grey.shade200,
                              filled: true,
                              prefixIcon: const Icon(Icons.key_rounded, color: Color.fromARGB(255, 232, 149, 40)),
                              hintText: 'New Password',
                              // suffixIcon: IconButton(
                              //     color: Colors.grey.shade400,
                              //     icon: Icon(_isObscure
                              //         ? Icons.visibility_off_rounded
                              //         : Icons.visibility),
                              //     onPressed: () {
                              //       setState(() {
                              //         _isObscure = !_isObscure;
                              //       });
                              //     })
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _retypepassword,
                          validator: (value) {
                            if (_password.text.isEmpty)
                            {
                              if (value!.isEmpty) 
                              {
                                return null;
                              }
                            }
              
                            else
                            {
                              if (value!.isEmpty) 
                              {
                                return 'Retype Password';
                              }
                            }
              
                            print(_password.text);
                            print(_retypepassword.text);
              
                            if (_password.text != _retypepassword.text) 
                            {
                              return 'Password didn\'t match';
                            }
                            return null;
                          },
              
                          obscureText: _isObscure1,
                          style: const TextStyle(fontSize: 20),
                          decoration:  InputDecoration(
                            border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(255, 40, 84, 232)) 
                          ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            prefixIcon: const Icon(Icons.lock_rounded, color: Color.fromARGB(255, 232, 149, 40),),
                            hintText: 'Re-Type New Password',
                            // suffixIcon: IconButton(
                              //     color: Colors.grey.shade400,
                              //     icon: Icon(_isObscure
                              //         ? Icons.visibility_off_rounded
                              //         : Icons.visibility),
                              //     onPressed: () {
                              //       setState(() {
                              //         _isObscure1 = !_isObscure1;
                              //       });
                              //     })
                          ),
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.only(top: 50, bottom: 20),
                        width: 600,
                        height: 55,
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            primary: const Color.fromARGB(255, 40, 84, 232)
                          ),

                          child: const Text('CONFIRM',
                            style: TextStyle(
                              fontSize: 25, 
                              letterSpacing: 3
                            ),
                          ),

                          onPressed: () async{
                            if (_formkey.currentState!.validate()) 
                            {
                              setState(() {
                                isLoading = true;
                              });

                              print("New Password");

                              await _forgotPassApi.newPassword(
                                email: widget.email,
                                password: _password.text,
                                confirmpassword: _retypepassword.text,
                              ).then((value) {
                                if(value){
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
                              }).whenComplete(
                                () => setState(
                                  () => isLoading = false,
                                ),
                              );

                            }
                          },
                        ),
                      ),

                    ]
                  )
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
          ],
        ),
      ),
    );
  }
}
                