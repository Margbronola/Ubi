// ignore_for_file: avoid_print

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:internapp/model/customer_model.dart';
import 'package:internapp/productpage.dart';
import 'package:internapp/profile_page.dart';

class CustomerDetailsPage extends StatefulWidget {
  const CustomerDetailsPage({ Key? key, required this.customer}) : super(key: key);
  final CustomerModel customer;

  @override
  State<CustomerDetailsPage> createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 40, 84, 232),
        elevation: 0,
        actions: <Widget>[
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),

            child: IconButton(
              onPressed: (){
                showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  constraints: BoxConstraints(
                    maxHeight: size.height,
                  ),
                  context: context,
                  builder: (_) => BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY:5),
                    child: const ProfilePage()
                  )
                );
              }, 
              icon: const Icon(Icons.person_rounded, color: Colors.blue)
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    width: size.width,
                    height: 90,
                    margin: const EdgeInsets.only(top: 30, bottom: 30),
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: const Text("Customer's Details", 
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  // Container(
                  //   height: 50,
                  //   alignment: Alignment.topRight,
                  //   padding: const EdgeInsets.only(top: 10),
                  //   margin: const EdgeInsets.symmetric(horizontal: 30),
                  //   child: const Icon(Icons.edit_note_rounded, color: Color.fromARGB(255, 232, 149, 40), size: 40)
                  // ),

                  Container(
                    alignment: Alignment.center,
                    width: size.width,
                    height: 120,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade300,
                      ),
                      child: const Icon(Icons.person_rounded, size: 80, color: Colors.grey,),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    width: 200,
                    height: 100,
                    child: Text(widget.customer.name , 
                      style: const TextStyle(
                        fontSize: 25, 
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ]
              ),
      
              // Container(
              //   margin: const EdgeInsets.only(top: 20),
              //   padding: const EdgeInsets.symmetric(horizontal: 30),
              //   height: 180,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: const [
              //       Text('Address: ', 
              //         style: TextStyle(
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold,
              //         )
              //       ),

              //       Divider(thickness: 5, color: Colors.transparent),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 50),
                    //   child: Text(widget.customer.phone, style: const TextStyle(fontSize: 20)),
                    // ),

                    // Divider(thickness: 15, color: Colors.transparent),

                    // Text("Phone Number: ", 
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.bold
                    //   )
                    // ),

                    // Divider(thickness: 5, color: Colors.transparent),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 50),
                    //   child: Text(widget.customer.phone, style: const TextStyle(fontSize: 20)),
                    // ),
              //     ]
              //   ),
              // ),

              Container(
                // padding: const EdgeInsets.only(top: 50,),
                margin: const EdgeInsets.fromLTRB(30, 60, 30, 10),
                child: SizedBox(
                  width: size.width,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(width: 3, color: Color.fromARGB(255, 40, 84, 232)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      primary: Colors.white
                    ),
                    
                    onPressed: () {
                      print(widget.customer.id);
                      Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => ProductPage(
                            isFromLocalPage: true,  
                            height: 685, 
                            cusid: widget.customer.id,
                          )
                        )
                      );
                    },

                    child: const Text('START NEW ORDER', 
                      style: TextStyle(
                        fontSize: 20, 
                        letterSpacing: 5, 
                        color: Color.fromARGB(255, 40, 84, 232)
                      )
                    )
                  ),
                ),
              ),

              // Container(
              //   // padding: const EdgeInsets.symmetric(vertical: 20),
              //   margin: const EdgeInsets.fromLTRB(30, 10, 30, 50),
              //   child: SizedBox(
              //     width: size.width,
              //     height: 55,
              //     child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //         side: const BorderSide(width: 3, color: Color.fromARGB(255, 40, 84, 232)),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10)
              //         ),
              //         primary: const Color.fromARGB(255, 40, 84, 232)
              //       ),
              //       onPressed: () {
              //         Navigator.push(
              //           context, MaterialPageRoute(
              //             builder: (context) => PendingOrderDetailsPage(
              //               cusid: widget.customer.id,
              //               cusname: widget.customer.name,
              //             )
              //           )
              //         );
              //       },
                        
              //       child: const Text('VIEW PENDING ORDER', 
              //         style: TextStyle(fontSize: 20, letterSpacing: 5, color: Colors.white),
              //       )
              //     ),
              //   ),
              // ),

            ],
          ),
        ),
      ),
    );
  }
}