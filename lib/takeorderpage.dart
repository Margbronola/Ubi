// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
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
                  //   Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   width: size.width,
                  //   height: 80,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Expanded(
                  //         child: TextField(
                  //           decoration: InputDecoration(
                  //             border: const OutlineInputBorder(
                  //               borderRadius: BorderRadius.all(Radius.circular(10)),
                  //             ),
                  //             enabledBorder: OutlineInputBorder(
                  //               borderSide: BorderSide(color: Colors.grey.shade300),
                  //             ),       
                  //             hintText: 'Search Customer',
                  //             hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  //             filled: true,
                  //             fillColor: Colors.grey.shade300,
                  //             suffixIconConstraints: const BoxConstraints(
                  //               maxHeight: double.maxFinite,
                  //             ),
                  //             contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                  //             suffixIcon:  Container(
                  //               width: 50,
                  //               height: 50,
                  //               decoration: const BoxDecoration(
                  //                 color: Color.fromARGB(255, 40, 84, 232),
                  //                 borderRadius: BorderRadius.only(
                  //                   topRight: Radius.circular(5),
                  //                   bottomRight: Radius.circular(5),
                  //                 ),
                  //               ),
                  //               child: const Icon(Icons.search_rounded, color: Colors.white),
                  //             )
                  //           ),
                  //         ),
                  //       ),
                  //       IconButton(
                  //         onPressed: (){
                  //           Navigator.push(
                  //             context, MaterialPageRoute(
                  //               builder: (context) => ScannerPage(isFromLocalPage: true,)));
                  //             }, 
                  //         icon: const Icon(Icons.qr_code_scanner_rounded),
                  //         color: const Color.fromARGB(255, 40, 84, 232),
                      
                  //       )
                  //     ],
                  //   ),
                  // ),
          
                    // const SizedBox(
                    //   height: 200,
                    // ),
          
                    Container(
                      height: 250,
                      width: size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('New Customer', 
                            style: TextStyle(
                              fontSize: 25, 
                              fontWeight: FontWeight.bold
                            )
                          ),
          
                          Center(
                            child: Container(
                              height: 58,
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
                              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                              // padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                controller: _customername,
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter Customer Name';
                                  }
                                  return null;
                                },
                                style: const TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                  // border: OutlineInputBorder(
                                  //   borderRadius: BorderRadius.all(Radius.circular(10)),
                                  // ),
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
                            margin: const EdgeInsets.only(top: 30),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ElevatedButton(
                              child: const Text('Confirm',
                                style: TextStyle(color: Colors.white, fontSize: 25, letterSpacing: 5)
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                primary: const Color.fromARGB(255, 40, 84, 232)
                              ),
                              onPressed: () async{
                                if(_formkey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                
                                  final String name = _customername.text;
          
                                  await cusAPI.addNewCustomer(name)
                                  .then((value) async{
                                    if(value != null){
                                      setState(() {
                                        cusAPI.getCustomer();
                                        // ignore: avoid_print
                                        print("New Customer ID: ${customerDetails!.id}");
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
                                      // ignore: avoid_print
                                      print('Customer Added');
                                    }
                                  }).whenComplete(
                                    () => setState(
                                      () => isLoading = false,
                                    ),
                                  );
                                  
                                  }else {
                                    // ignore: avoid_print
                                    print('Unsuccessful');
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