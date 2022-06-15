import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:internapp/model/pendingorderdetails_model.dart';
import 'package:internapp/profile_page.dart';
import 'package:internapp/viewmodel/pendingorderdetailsviewmodel.dart';
import 'package:internapp/services/API/ordertopreparedApi.dart';

// ignore: must_be_immutable
class PendingOrderDetailsPage extends StatefulWidget {
  PendingOrderDetailsPage({ Key? key, this.cusname = "", this.cusid = 0 }) : super(key: key);
   int cusid;
   String cusname;


  @override
  State<PendingOrderDetailsPage> createState() => _PendingOrderDetailsPageState();
}

class _PendingOrderDetailsPageState extends State<PendingOrderDetailsPage> {
  final PendingOrderDetailsViewModel _viewModel = PendingOrderDetailsViewModel.instance;
  final OrdertoPrepareByCustomerApi _ordertopreparedetails = OrdertoPrepareByCustomerApi();

  @override
  void initState() {
    _ordertopreparedetails.getPendingOrderDetails(customerID: widget.cusid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
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
        elevation: 5,
        backgroundColor: const Color.fromARGB(255, 40, 84, 232),
      ),

      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            Container(
              height: 60,
              width: size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                children: [
                  const Text('Customer: ', style: TextStyle(fontSize: 18)),
                  Text(widget.cusname, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                ],
              ),
            ),

            Container(
              color: Colors.greenAccent,
              width: size.width,
              height: 700,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: StreamBuilder<List<PendingOrderDetailsModel>>(
                stream: _viewModel.stream,
                builder: (_, snapshot){
                  if (snapshot.hasData && !snapshot.hasError){
                    if (snapshot.data!.isNotEmpty){
                      return ListView.separated(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext ctx, int index){
                          // ignore: unnecessary_null_comparison
                          if(snapshot.data![index] != null){
                            return Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.grey.shade200,
                              height: 150,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 95,
                                    height: 130,
                                    child:  
                                    // snapshot.data![index].product.images.isEmpty ? 
                                    SizedBox(
                                      width: 95,
                                      height: 130,
                                      child: Image.asset('assets/images/placeholder.jpg', fit: BoxFit.fitWidth),
                                    ) 
                                    // : Image.network("${Network.imageUrl}/${snapshot.data![index].product.images[0].url}",
                                    //   fit: BoxFit.cover,
                                    // ),
                                  ),
                            
                                  SizedBox(
                                    width: 200,
                                    height: 145,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 45,
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.only(left: 5),
                                              child:  const Text("Product Quantity",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                                )
                                              ),
                                            ),

                                            Container(
                                              width: 150,
                                              height: 40,
                                              alignment: Alignment.center, 
                                              child: const Text("Product Name",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                                )
                                              ),
                                            ),

                                          ],
                                        ),

                                        Container(
                                          width: 200,
                                          height: 85,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: const BorderRadius.all (Radius.circular(10)),
                                          ),
                                          padding: const EdgeInsets.all(5),
                                          alignment: Alignment.center,
                                          child: const Text("Comment",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            );
                          }

                          return Container(
                            padding: const EdgeInsets.all(10),
                            color: Colors.grey.shade200,
                            height: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 95,
                                  height: 110,
                                  child:  
                                  // snapshot.data![index].product.images.isEmpty ? 
                                  SizedBox(
                                    width: 95,
                                    height: 110,
                                    child: Image.asset('assets/images/placeholder.jpg', fit: BoxFit.fitWidth),
                                  ) 
                                  // : Image.network(
                                  //   "${Network.imageUrl}/${snapshot.data![index].product.images[0].url}",
                                  //   fit: BoxFit.cover,
                                  // ),
                                ),
                          
                                Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 60,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.only(left: 5),
                                      child:  const Text("Product Quantity",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                    ),

                                    Container(
                                      width: 150,
                                      height: 60,
                                      alignment: Alignment.center, 
                                      child: const Text("Product Name",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                    ),

                                  ],
                                ),
                              ]
                            )
                          );
                        }, 
                        separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.transparent)
                      ); 
                    }
                    return const Center(
                      child: Text('No pending orders',
                        style: TextStyle(fontSize: 30)
                      )
                    );
                  }
                  return const Center(child: CircularProgressIndicator.adaptive());
                }
              ),
            ),

          ]
        ),
      ),
    );
  }
}