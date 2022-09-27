// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internapp/global/access.dart';
import 'package:internapp/productpage.dart';
import 'package:internapp/services/API/customerApi.dart';

class TakeOrderPage extends StatefulWidget {
  const TakeOrderPage({ Key? key }) : super(key: key);

  @override
  State<TakeOrderPage> createState() => _TakeOrderPageState();
}

class _TakeOrderPageState extends State<TakeOrderPage> {
  bool isLoading = false;
  final TextEditingController _customername = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final CustomerAPI cusAPI = CustomerAPI();

  @override
  void initState() {
    cusAPI.getCustomer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(            
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Form(
            key: _formkey,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 250,
                      width: size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('New Customer', 
                            style: TextStyle(
                              fontSize: 23, 
                              fontWeight: FontWeight.bold
                            )
                          ),
          
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0,3),
                                    blurRadius: 10,
                                    color: Colors.grey.shade400
                                  )
                                ]
                              ),
                              margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                              child: TextFormField(
                                controller: _customername,
                                keyboardType: TextInputType.name,
                                style: const TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey.shade200),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey.shade200) 
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "Type Customer name",
                                ),
                              ),
                            ),
                          ),
          
                          Container(
                            height: 50,
                            width: size.width,
                            margin: const EdgeInsets.only(top: 25),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ElevatedButton(
                              child: const Text('CONFIRM',
                                style: TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 5)
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                primary: const Color.fromARGB(255, 40, 84, 232)
                              ),
                              onPressed: () async{
                                if(_customername.text.isNotEmpty) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                
                                  final String name = _customername.text;
          
                                  await cusAPI.addNewCustomer(name).then((value) async{
                                    if(value != null){
                                      setState(() {
                                        cusAPI.getCustomer();
                                      });

                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15)
                                          ),
                                          content: const SizedBox(
                                            width: 150,
                                            height: 50,
                                            child: Center(
                                              child: Text("Successfully Added", 
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold, 
                                                  fontSize: 20
                                                )
                                              ),
                                            ),
                                          ),

                                          actions: [
                                            MaterialButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context, MaterialPageRoute(
                                                    builder: (context) => ProductPage(
                                                      isFromLocalPage: true, 
                                                      height: 685,
                                                      cusname: _customername.text,
                                                      cusid: customerDetails!.id,
                                                    )
                                                  )
                                                );
                                              },
                                              child: const Text("Continue"),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  }).whenComplete(
                                    () => setState(
                                      () => isLoading = false,
                                    ),
                                  );
                                  
                                } else {
                                  print('Unsuccessful');
                                  Fluttertoast.showToast(
                                    msg: "Add Customer name"
                                  );
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
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
      ),
    );
  }
}