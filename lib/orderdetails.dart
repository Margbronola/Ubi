import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:internapp/global/network.dart';
import 'package:internapp/model/order_model.dart';
import 'package:internapp/model/orderproduct_model.dart';
import 'package:internapp/profile_page.dart';
import 'package:internapp/services/API/addpaymentApi.dart';
import 'package:internapp/services/API/orderdetailsApi.dart';
import 'package:jiffy/jiffy.dart';

// ignore: must_be_immutable
class OrderDetailsPage extends StatefulWidget {
  OrderDetailsPage({ Key? key,
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
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _change = TextEditingController();
  final AddPayment _addPayment = AddPayment();
  final OrderDetailsApi _orderApi = OrderDetailsApi();
  bool isLoading = false;
  bool visiblewidget = false;
  bool visiblecontainer = true;
  OrderModel? _displayorder;

  fetchDetails() async {
    await _orderApi.getOrderdetails(orderId: widget.orderid).then((value) 
    {
      if(value != null){
        setState(() {
          _displayorder = value;
        });
      }else{
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void initState(){
    if(widget.orderid != 0){
      fetchDetails();
    }
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
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
          child: _displayorder == null ? const Center(
            child: CircularProgressIndicator(),
          ) : ListView(
            children: [
              Container(
                width: size.width,
                height: 55,
                margin: const EdgeInsets.only(top: 25, bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Text('Customer: ', style: TextStyle(fontSize: 20)),
                          Text(widget.cusname,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                          ),
                        ],
                      ),
                    ),
                    
                    Text(date,
                      style: const TextStyle(fontSize: 20)
                    )
                
                  ]
                ),
              ),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _displayorder!.orderproduct.length,
                itemBuilder: (BuildContext ctx, int index){
                  OrderProductModel details = _displayorder!.orderproduct[index];

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
              ),

              Container(
                height: 60,
                padding: const EdgeInsets.only(right: 20, top: 15),
                margin: const EdgeInsets.only(bottom: 0, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('Total   ',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                             
                    Container(
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black12,
                      ),
                      padding: const EdgeInsets.fromLTRB(5, 10, 20, 10),
                      child: Text("${_displayorder!.total}", 
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), 
                        textAlign: TextAlign.end
                      )
                    )

                  ]
                ),
              ),

              if(widget.status == "Pending")...{
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
                              height: 195,
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: Column(
                                children: [
                                  Divider(color:Colors.grey.shade400, thickness: 5),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Row(
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
                                                    _change.text = (double.parse(_amount.text) - double.parse(_displayorder!.total.toString())).toString();
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
                                                  readOnly: true,
                                                  textAlign: TextAlign.center,
                                                  controller: _change,      
                                                )
                                              ),
                                            ),
                                          ]
                                        ),
                                      ],
                                    ),
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
                                        if(double.parse(_amount.text)  >= double.parse(_displayorder!.total.toString())){
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
                                                        
                                                        Text("Php ${_displayorder!.total.toString()}",
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
                                                
                                                        Text('Php ${_amount.text.isNotEmpty ? double.parse(_amount.text) - (_displayorder!.total.toString().isNotEmpty ? double.parse(_displayorder!.total.toString()) : 0.0) : "0.0"}',
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
              }

              else...{
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(color:Colors.grey.shade400, thickness: 5),
                ),

                SizedBox(
                  height: 170,
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
                        height: 100,
                        padding: const EdgeInsets.fromLTRB(25, 5, 25, 0),
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
                                              color: Colors.black12,
                                              borderRadius: BorderRadius.all(Radius.circular(10))
                                            ),
                                            child: Center(
                                              child: Text(_displayorder?.payments?.paid.toStringAsFixed(2)??"0.0" ,
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
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                  child: Center(
                                    child: Text(_displayorder?.payments?.change.toStringAsFixed(2)??"0.0" ,
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
              }
            ],
          ),
        ),
      )
    );
  }
}