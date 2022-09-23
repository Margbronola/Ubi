// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:internapp/new_password_page.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:internapp/services/API/forgotpasswordApi.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// ignore: must_be_immutable
class VerificationPage extends StatefulWidget {
  String email;
  VerificationPage({Key? key, required this.email}) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final ForgotPassApi _forgotPassApi = ForgotPassApi();
  bool isLoading = false;
  bool _onEditing = true;
  String otp = "";

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
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    controller: scrollController,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
                        child: const Text('VERIFICATION CODE', 
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(30,15,30,0),
                        child: Text('Please type the verification code sent to ${widget.email}',
                          style: const TextStyle(
                            color: Colors.black, 
                            fontSize: 17,
                            letterSpacing: .5
                          ),
                          textAlign: TextAlign.center
                        ),
                      ),

                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 50),
                        padding: const EdgeInsets.fromLTRB(40,0,40,0),
                        child: VerificationCode(
                          underlineUnfocusedColor: Colors.grey.shade500,
                          underlineWidth: 3,
                          autofocus: true,
                          textStyle: const TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                          ),
                          underlineColor: const Color.fromARGB(255, 19, 1, 124),
                          keyboardType: TextInputType.number,
                          length: 4,
                          cursorColor: Colors.blue.shade800,
                          onCompleted: (String value){
                            setState(() {
                              print(value);
                              otp = value;
                            });
                          }, 

                          onEditing: (bool value){
                            setState(() {
                              _onEditing = value;
                            });
                            if (!_onEditing) FocusScope.of(context).unfocus();
                          }
                        ),
                      ),                      

                      Container(
                        width: 600,
                        height: 55,
                        margin: const EdgeInsets.only(top: 40, bottom: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            primary: const Color.fromARGB(255, 40, 84, 232)
                          ),

                          child: const Text('CONTINUE',
                            style: TextStyle(fontSize: 20, letterSpacing: 3),
                          ),

                          onPressed: () async{
                            setState(() {
                              isLoading = true;
                            });

                            print("Verify Otp");

                            await _forgotPassApi.verifyOtp(
                              email: widget.email,
                              otp: otp,
                            ).then((value) {
                              if(value){
                                print('Successful');
                                Navigator.push(
                                  context, MaterialPageRoute(
                                    builder: (context) => NewPasswordPage(email: widget.email)
                                  )
                                );
                              }
                            }).whenComplete(
                              () => setState(
                                () => isLoading = false,
                              ),
                            );
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
              child: Center(
                child: LoadingAnimationWidget.prograssiveDots(color: const Color.fromARGB(255, 40, 84, 232), size: 50),
              ),
            ): Container()
          ],
        ),
      ),
    );
  }
}