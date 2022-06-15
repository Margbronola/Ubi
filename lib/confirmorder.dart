import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:internapp/global/network.dart';
import 'package:internapp/model/order_model.dart';
import 'package:internapp/model/orderproduct_model.dart';
import 'package:internapp/profile_page.dart';
import 'package:internapp/services/API/addpaymentApi.dart';
import 'package:internapp/services/API/orderdetailsApi.dart';
import 'package:internapp/viewmodel/todaysorderdetailsviewmodel.dart';
import 'package:jiffy/jiffy.dart';

// ignore: must_be_immutable
class ConfirmOrderPage extends StatefulWidget {
  ConfirmOrderPage({ Key? key,
      this.orderid = 0,
      this.cusid = 0,
      this.cusname = "",
      this.isfromOrderPage = false,
      this.isfromPendingOrder = false,
      this.status = ""}) : super(key: key);

  int orderid;
  int cusid;
  String cusname;
  bool isfromOrderPage;
  bool isfromPendingOrder;
  String status;

  @override
  State<ConfirmOrderPage> createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _change = TextEditingController();
  final OrdersDetailsViewModel _viewModel = OrdersDetailsViewModel.instance;
  final AddPayment _addPayment = AddPayment();
  final TodaysOrderdetailsApi _orderApi = TodaysOrderdetailsApi();
  bool isLoading = false;
  bool visiblewidget = false;
  bool visiblecontainer = true;

  @override
  void initState() {
    setState(() {
      _orderApi.getOrderdetails(orderId: widget.orderid);
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    DateTime current = DateTime.now();
    String date = Jiffy(current).format('MMMM dd, yyyy');
    
    return Scaffold(
      appBar: widget.isfromPendingOrder ? AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    constraints: BoxConstraints(
                      maxHeight: size.height,
                    ),
                    context: context,
                    builder: (_) => BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: const ProfilePage()
                    )
                  );
                },
                icon: const Icon(Icons.person_rounded, color: Colors.blue)
              ),
            ),
          ),
        ],
        elevation: 5,
        backgroundColor: const Color.fromARGB(255, 40, 84, 232),
      ) : null,
    
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: ListView(
            children: [
              Container(
                width: size.width,
                height: 55,
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.isfromOrderPage ? Container() :
                    Container(
                      alignment: Alignment.centerRight,
                      width: size.width,
                      height: 20,
                      child: Text(date,
                        style: const TextStyle(fontSize: 20)
                      )
                    ),

                    Row(
                      children: [
                        const Text('Customer: ', style: TextStyle(fontSize: 20)),
                        Text(widget.cusname,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                  ]
                ),
              ),

              StreamBuilder<OrderModel>(
                stream: _viewModel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && !snapshot.hasError) {
                    final TextEditingController _totalController = TextEditingController()..text = snapshot.data!.total.toString();
                    
                    if(widget.status == "Pending"){
                      return Column(
                        children: [
                          SizedBox(
                            height: 450,
                            child: 
                            ListView.separated(
                              itemBuilder: (_, index) {
                                final OrderProductModel details = snapshot.data!.orderproduct[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    color: Colors.grey.shade200,
                                    height: 100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          height: 100,
                                          child: details.product.images.isNotEmpty ? 
                                          Image.network("${Network.imageUrl}${details.product.images[0].url}",
                                            fit: BoxFit.cover
                                          ) : Image.asset('assets/images/placeholder.jpg',
                                            fit: BoxFit.fitWidth
                                          )
                                        ),
                        
                                        Container(
                                          margin: const EdgeInsets.only(top: 5),
                                          child: Column(
                                            children: [
                                              Center(
                                                child: Container(
                                                  width: 190,
                                                  height: 30,
                                                  padding: const EdgeInsets.only(left: 15),
                                                  child: Text( details.prepared ? "Prepared" : "To Prepare",
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color.fromARGB(255, 40, 84, 232)
                                                    ),
                                                  ),
                                                ),
                                              ),
                              
                                              SizedBox(
                                                width: 190,
                                                height: 45,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 30,
                                                      child: Text(details.qty.toString(),
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold
                                                        )
                                                      ),
                                                    ),

                                                    SizedBox(
                                                      width: 160,
                                                      child: Text(details.product.name,
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold
                                                        )
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        SizedBox(
                                          width: 80,
                                          height: 100,
                                          child: Center(
                                            child: Text("P${details.price}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.transparent),
                              itemCount: snapshot.data!.orderproduct.length,
                            ),
                          ),

                          Container(
                            height: 60,
                            padding: const EdgeInsets.only(right: 20, top: 15),
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text('Total   ',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                
                                SizedBox(
                                  width: 150,
                                  height: 40,
                                  child: TextFormField(
                                    controller: _totalController,
                                    textAlign: TextAlign.end,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 2
                                        )
                                      ),
                                      fillColor: Colors.grey.shade300,
                                      filled: true,
                                    ),
                                  ),
                                )

                              ]
                            ),
                          ),

                          Visibility(
                            visible: visiblecontainer,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [

                                  Visibility(
                                    visible: true,
                                    child: Visibility(
                                      child: Container(
                                        width: size.width,
                                        margin: const EdgeInsets.only(top: 5),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            side: const BorderSide(
                                              width: 3,
                                              color: Color.fromARGB(255, 40, 84, 232)
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:BorderRadius.circular(10)
                                            ),
                                            primary: const Color.fromARGB(255, 40, 84, 232),
                                            padding: const EdgeInsets.symmetric(vertical: 20),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              visiblewidget = !visiblewidget;
                                              visiblecontainer = !visiblecontainer;
                                            });
                                          },
                                          child: const Text('ADD PAYMENT',
                                            style: TextStyle(
                                              fontSize: 20,
                                              letterSpacing: 3,
                                              color: Colors.white
                                            )
                                          ),
                                        )
                                      ),

                                    ),
                                  ),
                                ]
                              ),
                            ),
                            
                            replacement: Container(
                              height: 190,
                              color: Colors.grey.shade300,
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Amount Received  ',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight:
                                              FontWeight.bold
                                            )
                                          ),

                                          Container(
                                            height: 50,
                                            width: 170,
                                            margin: const EdgeInsets.only(top: 10),
                                            child: TextFormField(
                                              controller: _amount,
                                              keyboardType: const TextInputType.numberWithOptions(),
                                              onChanged: (__text) {
                                                setState(() {
                                                  _change.text = (double.parse(_amount.text) - double.parse(_totalController.text)).toString();
                                                });
                                              },
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(fontSize: 18),
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(10)
                                                  ),
                                                ),
                                                fillColor: Colors.white,
                                                filled: true,
                                              ),
                                            ),
                                          ),
                                        ]
                                      ),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Change',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                            )
                                          ),
                                          
                                          Container(
                                            height: 50,
                                            width: 170,
                                            margin: const EdgeInsets.only(top: 10),
                                            child: Center(
                                              child: TextFormField(
                                              textAlign: TextAlign.center,
                                              controller: _change,      
                                              )
                                            ),
                                          ),
                                        ]
                                      ),
                                    ],
                                  ),
                                  
                                  Container(
                                    width: size.width,
                                    height: 50,
                                    margin: const EdgeInsets.only(top: 15),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        primary: const Color.fromARGB(255, 40, 84, 232)
                                      ),
                                      onPressed: () async {
                                        if(double.parse(_amount.text)  >= double.parse(_totalController.text)){
                                        setState(() {
                                          isLoading = true;
                                        });

                                        await _addPayment.paymentbyOrder(
                                          orderID: widget.orderid,
                                          amount: double.parse(_amount.text),
                                        ).whenComplete(
                                          () => setState(
                                            () => isLoading = false,
                                          ),
                                        );

                                        showDialog(
                                          barrierDismissible: false,
                                          context: context, builder: (ctx) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:BorderRadius.circular(10)
                                            ),
                                            title: Container(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration:BoxDecoration(  
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey.shade200,
                                                ),
                                                child: IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pushNamedAndRemoveUntil(
                                                      '/landingPage', (Route<dynamic> route) => false
                                                    );
                                                  },
                                                  icon: Icon(
                                                    Icons.close_rounded,
                                                    color: Colors.grey.shade900,
                                                  )
                                                ),
                                              ),
                                            ),

                                            content: Container(
                                              width: 300,
                                              height: 330,
                                              padding: const EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(bottom: 10),
                                                      child: Center(
                                                        child: Text('PAYMENT RECEIVE',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Color.fromARGB(255, 15, 41, 142),
                                                            fontSize: 25,
                                                            letterSpacing: 3,
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    const Padding(
                                                      padding:EdgeInsets.only(top: 20),
                                                      child: Text('From',
                                                        style: TextStyle(fontSize: 19)
                                                      ),
                                                    ),

                                                    Center(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom: 50),
                                                        child: Text(widget.cusname,
                                                          style: const TextStyle(
                                                            fontSize: 22,
                                                            fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                        
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        const Text('Amount Due',
                                                          style:TextStyle(fontSize:18,)
                                                        ),
                                                        
                                                        Text("Php ${snapshot.data!.total}",
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 18
                                                          )
                                                        ),
                                                      ],
                                                    ),
                                                            
                                                    const Divider(thickness: 5, color: Colors.transparent),

                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        const Text('Amount Receive',
                                                          style: TextStyle(fontSize:18,)
                                                        ),
                                                              
                                                        Text('Php ${_amount.text}.0',
                                                          style: const TextStyle(fontSize: 18)
                                                        ),
                                                      ],
                                                    ),
                                                          
                                                    const Divider(thickness: 5, color: Colors.transparent),

                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        const Text('Change',
                                                          style: TextStyle(fontSize: 18)
                                                        ),
                                                
                                                        Text('Php ${_amount.text.isNotEmpty ? double.parse(_amount.text) - (_totalController.text.isNotEmpty ? double.parse(_totalController.text) : 0.0) : "0.0"}',
                                                          style: const TextStyle(fontSize:18)
                                                        ),
                                                      ],
                                                    ),

                                                    // Container(
                                                    //   width: size.width,
                                                    //   height: 50,
                                                    //   margin: const EdgeInsets.only(top: 60),
                                                    //   child:ElevatedButton(
                                                    //     style: ElevatedButton.styleFrom(
                                                    //       shape: RoundedRectangleBorder(
                                                    //         borderRadius: BorderRadius.circular(10)
                                                    //       ),
                                                    //       primary:const Color.fromARGB(255, 15, 41, 142)
                                                    //     ),
                                                    //     child: const Text('Go to Pending Orders',
                                                    //       style: TextStyle(
                                                    //         color: Colors.white,
                                                    //         fontSize: 20
                                                    //       )
                                                    //     ),
                                                    //     onPressed: () {
                                                    //       Navigator.of(context).pushNamedAndRemoveUntil(
                                                    //         '/landingPage', (Route<dynamic> route) => false
                                                    //       );
                                                    //     },
                                                    //   )
                                                    // )
                                                  ],
                                                ),
                                              ),
                                            )
                                          );
                                        }

                                        else{
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25)
                                              ),

                                              title: const Text("Payment Unsuccessful",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20
                                                )
                                              ),

                                              content: const Text("Insufficient amount", textAlign: TextAlign.center),

                                              actions: <Widget>[
                                                // ignore: deprecated_member_use
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: const Text("Close"),
                                                )
                                              ]
                                            )
                                          );
                                        }
                                      },

                                      child: const Text('Confirm Payment',
                                        style: TextStyle(
                                          fontSize: 25,
                                          letterSpacing: 3
                                        )
                                      ),
                                    )
                                  )

                                ],
                              ),
                            ),
                          ) 
                        ]
                      );
                    }

                    else{
                      return Column(
                        children: [
                          SizedBox(
                            height: 450,
                            child: 
                            ListView.separated(
                              itemBuilder: (_, index) {
                                final OrderProductModel details = snapshot.data!.orderproduct[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    color: Colors.grey.shade200,
                                    height: 100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          height: 100,
                                          child: details.product.images.isNotEmpty ? 
                                          Image.network("${Network.imageUrl}${details.product.images[0].url}",
                                            fit: BoxFit.cover
                                          ) : Image.asset('assets/images/placeholder.jpg',
                                            fit: BoxFit.fitWidth
                                          )
                                        ),
                        
                                        Container(
                                          margin: const EdgeInsets.only(top: 5),
                                          child: Column(
                                            children: [
                                              Center(
                                                child: Container(
                                                  width: 190,
                                                  height: 30,
                                                  padding: const EdgeInsets.only(left: 15),
                                                  child: Text(details.prepared ? "Prepared" : "To Prepare",
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color.fromARGB(255, 40, 84, 232)
                                                    ),
                                                  ),
                                                ),
                                              ),
                              
                                              SizedBox(
                                                width: 190,
                                                height: 45,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 30,
                                                      child: Text(details.qty.toString(),
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold
                                                        )
                                                      ),
                                                    ),

                                                    SizedBox(
                                                      width: 160,
                                                      child: Text(details.product.name,
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold
                                                        )
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        SizedBox(
                                          width: 80,
                                          height: 100,
                                          child: Center(
                                            child: Text("P${details.price}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.transparent),
                              itemCount: snapshot.data!.orderproduct.length,
                            ),
                          ),

                          Container(
                            height: 60,
                            padding: const EdgeInsets.only(right: 20, top: 15),
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text('Total   ',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                
                                SizedBox(
                                  width: 150,
                                  height: 40,
                                  child: TextFormField(
                                    controller: _totalController,
                                    textAlign: TextAlign.end,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 2
                                        )
                                      ),
                                      fillColor: Colors.grey.shade300,
                                      filled: true,
                                    ),
                                  ),
                                )

                              ]
                            ),
                          ),

                          Container(
                            height: 170,
                            margin: const EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: size.width,
                                  height: 50,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 20),
                                  child: const Text('Payment Received', 
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 40, 84, 232)
                                    )
                                  ),
                                ),

                                Container(
                                  width: size.width,
                                  height: 120,
                                  color: Colors.grey.shade200,
                                  padding: const EdgeInsets.all(25),
                                  child: Row(
                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Amount Received  ',
                                            style: TextStyle(
                                              fontSize: 20,
                                            )
                                          ),

                                          Container(
                                            height: 40,
                                            width: 150,
                                            margin: const EdgeInsets.only(top: 10),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(Radius.circular(10))
                                            ),
                                            child: Center(
                                              child: Text(snapshot.data!.payments?.paid.toStringAsFixed(2)??"0.0" ,
                                                style: const TextStyle(
                                                  fontSize: 20, 
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          ),
              
                                        ]
                                      ),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Change',
                                            style: TextStyle(
                                              fontSize: 20,
                                            )
                                          ),
                                                  
                                          Container(
                                            height: 40,
                                            width: 150,
                                            margin: const EdgeInsets.only(top: 10),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(Radius.circular(10))
                                            ),
                                            child: Center(
                                              child: Text(snapshot.data!.payments?.change.toStringAsFixed(2)??"0.0" ,
                                                style: const TextStyle(
                                                  fontSize: 20, 
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          ),
                  
                                        ]
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          )
                        ]
                      );
                    }

                  }
                  return Text(snapshot.error.toString());
                }
              ) 

            ],
          ),
        ),
      )
    );
  }
}