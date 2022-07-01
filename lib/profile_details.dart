import 'package:flutter/material.dart';
import 'package:internapp/global/access.dart';
import 'package:internapp/services/API/auth.dart';

class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({ Key? key, required this.callback }) : super(key: key);
  final ValueChanged<bool>? callback;
  
  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  bool isLoading = false;
  bool _isDisabled = true;
  bool visiblewidget = false;
  late TextEditingController _name = TextEditingController();
  late TextEditingController _phone = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final Auth _auth = Auth();

  @override
  void initState(){
    super.initState();
    _name =  TextEditingController(text: loggedUser!.name);
    _phone = TextEditingController(text: loggedUser!.phone);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          DraggableScrollableSheet(
          minChildSize: .08,
          initialChildSize: .65,
          maxChildSize: .65,
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
                  controller: scrollController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(left: 30, bottom: 10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade100,
                            ),
                            child: const Icon(Icons.person_rounded, size: 60, color: Colors.grey,),
                          ),
              
                          Container(
                            height: 100,
                            width: 210,
                            margin: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 195,
                                  height: 45,
                                  child: TextFormField(
                                    controller: _name,
                                    enabled: !_isDisabled,
                                    keyboardType: TextInputType.name,
                                    onTap: (){
                                      _name.clear();
                                    },
                                    style: const TextStyle(fontSize: 25),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey, width: 2)
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey, width: 2)
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                  ),
                                ),
              
                                Container(
                                  width: 150,
                                  height: 20,
                                  padding: const EdgeInsets.only(left: 15),
                                  margin: const EdgeInsets.only(top: 5),
                                  child: Text(loggedUser?.position??"FETCHING DETAILS",
                                    style: const TextStyle(
                                      fontSize: 22, 
                                      color: Color.fromARGB(255, 232, 149, 40)
                                    )
                                  )
                                ),
                              ],
                            ),
                          ),
              
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: IconButton(
                              onPressed: (){
                                setState(() {
                                  _isDisabled = !_isDisabled;
                                  visiblewidget = !visiblewidget;
                                });
                              }, 
                              icon: const Icon(Icons.edit, color: Color.fromARGB(255, 232, 149, 40), size: 30)
                            ),
                          )
                        ],
                      ),
                    ),
              
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Divider(color:Colors.grey.shade300, thickness: 3),
                    ),
              
                    const Padding(
                      padding: EdgeInsets.only(left: 60, right: 60, top: 20),
                      child: Text('Contact',
                        style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ),
              
                    Container(
                      width: 100,
                      height: 50,
                      margin: const EdgeInsets.only(top: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 90),
                      child: TextFormField(
                        controller: _phone,
                        enabled: !_isDisabled,
                        keyboardType: TextInputType.phone,
                        onTap: (){
                          _phone.clear();
                        },
                        style: const TextStyle(fontSize: 18),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 2)
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 2)
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
              
                    const Padding(
                      padding: EdgeInsets.only(left: 60, right: 60, top: 40),
                      child: Text('Email',
                        style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ),
              
                    Container(
                      width: 100,
                      height: 50,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 65),
                      child: TextFormField(
                        enabled: false,
                        style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          filled: true,
                          hintText: loggedUser?.email ?? "FETCHING DETAILS",
                          hintStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
              
                    FocusScope.of(context).hasFocus != true ?
                    Visibility(
                      visible: visiblewidget,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20, left: 30, right: 30, top: 20),
                        width: size.width,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            primary: const Color.fromARGB(255, 40, 84, 232)
                          ),
                          
                          onPressed: () async {
                            if(_formkey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                          
                              final String newName = _name.text.isEmpty?loggedUser!.name:_name.text;
                              final String newPhoneNumber = _phone.text.isEmpty?loggedUser!.phone:_phone.text;
                                      
                              await _auth.updateUserData(newName, newPhoneNumber)
                              .then((value) async {
                                if(value){
                                  setState(() {
                                    loggedUser!.name = newName;
                                    loggedUser!.phone = newPhoneNumber;
                                  });
                                  widget.callback!(true);
                                  Navigator.of(context).pop();
                                }
                              }).whenComplete(
                                () => setState(
                                  () => isLoading = false,
                                ),
                              );
                            }
                          },
                          child: const Text('SAVE', style: TextStyle(fontSize: 25, letterSpacing: 5))
                        ),
                      ),
                    ) : Visibility(
                      visible: visiblewidget,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 320, left: 30, right: 30, top: 20),
                        width: size.width,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            primary: const Color.fromARGB(255, 40, 84, 232)
                          ),
                          
                          onPressed: () async {
                            if(_formkey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                          
                              final String newName = _name.text.isEmpty?loggedUser!.name:_name.text;
                              final String newPhoneNumber = _phone.text.isEmpty?loggedUser!.phone:_phone.text;
                                      
                              await _auth.updateUserData(newName, newPhoneNumber)
                              .then((value) async {
                                if(value){
                                  setState(() {
                                    loggedUser!.name = newName;
                                    loggedUser!.phone = newPhoneNumber;
                                  });
                                  widget.callback!(true);
                                  Navigator.of(context).pop();
                                }
                              }).whenComplete(
                                () => setState(
                                  () => isLoading = false,
                                ),
                              );
                            }
                          },
                          child: const Text('SAVE', style: TextStyle(fontSize: 25, letterSpacing: 5))
                        ),
                      ),
                    )
              
                    ],
                  ),
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
          ) : Container()
        ]
      ),
    );
  }
}