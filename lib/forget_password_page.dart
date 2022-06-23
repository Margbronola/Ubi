// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:internapp/services/API/forgotpasswordApi.dart';
import 'package:internapp/verification_page.dart';

// ignore: use_key_in_widget_constructors
class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final ForgotPassApi _forgotPassApi = ForgotPassApi();
  bool isLoading = false;

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
                minChildSize: .1,
                initialChildSize: .45,
                maxChildSize: .45,
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
                          child: const Text('FORGOT PASSWORD', 
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              letterSpacing: 3,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
    
                        const Padding(
                          padding: EdgeInsets.fromLTRB(40,10,40,0),
                          child: Text('Enter your email to get verification code',
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
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Email';
                              }
    
                              if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                                return 'Please enter a valid Email';
                              }
                              return null;
                            },

                            onSaved: (email) {},
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
                              prefixIcon: const Icon(Icons.mail_rounded, color: Color.fromARGB(255, 232, 149, 40)),
                              hintText: 'Email',
                            ),
                          ),
                        ),
    
                        Container(
                          margin: const EdgeInsets.only(top: 40, bottom: 20),
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
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });

                                print("Request Otp");

                                await _forgotPassApi.requestOtp(email: _email.text)
                                .then((value) {
                                  print('Successful');
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => VerificationPage(email: _email.text)
                                    ));
                                  // if(value){
                                    
                                  // }
                                }).whenComplete(
                                  () => setState(
                                    () => isLoading = false,
                                  ),
                                );

                                return;
                              } 
                              else {
                                print('Unsuccessful');
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
      ),
    );
  }
}