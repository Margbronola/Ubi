// ignore_for_file: avoid_print

import 'dart:ui';
import 'package:internapp/model/cartdetails_model.dart';
import 'package:internapp/model/displaycart_model.dart';
import 'package:internapp/productdetails.dart';
import 'package:internapp/services/API/cartApi.dart';
import 'package:internapp/services/API/confirmorderApi.dart';
import 'package:internapp/services/API/deleteupdateorder.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/material.dart';
import 'package:internapp/productpage.dart';
import 'package:internapp/profile_page.dart';
import 'package:internapp/global/network.dart';
import 'package:internapp/model/product_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:internapp/services/API/addpaymentApi.dart';

// ignore: must_be_immutable
class CartDetailsPage extends StatefulWidget {
  CartDetailsPage(
    {Key? key,
      required this.product,
      this.qty = 0,
      this.comment = "none",
      this.cartcusid = 0,
      this.cusname = "",
      this.total = 0.0,
      this.isfromPendingOrder = false,
    }) : super(key: key);

  ProductModel product;
  int cartcusid;
  int qty;
  String comment;
  String cusname;
  bool isfromPendingOrder;
  double total;

  @override
  State<CartDetailsPage> createState() => _CartDetailsPageState();
}

class _CartDetailsPageState extends State<CartDetailsPage> {
  final DeleteUpdateOrderCart _deleteupdateorder = DeleteUpdateOrderCart();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _change = TextEditingController();
  final ConfirmOrder _confirmOrder = ConfirmOrder();
  final CartApi _api = CartApi();
  final AddPayment _addPayment = AddPayment();
  bool _disableConfirmButton = true;
  bool visiblecontainer = true;
  bool _enableSlidable = true;
  bool visiblewidget = false;
  bool isLoading = false;
  DisplayCartModel? _displayData;

  fetchDetails() async {
    await _api.getCartDetails(cartCustomerId: widget.cartcusid).then((value) {
      if(value != null){
        setState(() {
          _displayData = value;
        });
      }else{
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void initState(){
    if(widget.cartcusid != 0){
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
    
    void edit(BuildContext context, int cartId, int qty, String comment, ProductModel product, {required ValueChanged<CartDetailsModel> callback,}) {
      Navigator.push(
        context, MaterialPageRoute(
          builder: (context) => ProductDetailsPage(
            onUpdateCallback: callback,
            cartId: cartId,
            quantity: qty,
            comment: comment,
            product: product,
            isfromOrderDetails: true,
          )
        )
      );
    }

    void delete(BuildContext context, int cartId, int cartCustomer) async{
      setState(() {
        isLoading = true;
      });

      await _deleteupdateorder.delete(cartID: cartId)
      .then((value){
        setState(() {
          fetchDetails();
        });
      }).whenComplete(
        () => setState(
          () => isLoading = false,
        ),
      );
    }


    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
              )
            ],
          ),
        ],
        elevation: 5,
        backgroundColor: const Color.fromARGB(255, 40, 84, 232),
      ),
    
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: _displayData == null ? const Center(
            child: CircularProgressIndicator(),
          ) : ListView(
            children: [
              Container(
                width: size.width,
                height: 50,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Customer: ', style: TextStyle(fontSize: 20)),
                          Text(_displayData!.customer == null ? "N/A" : _displayData!.customer!.name,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                          ),
                        ],
                      ),
                    ),

                    Text(date,
                      style: const TextStyle(fontSize: 20)
                    ),
                  ]
                ),
              ),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _displayData!.carts.length,
                itemBuilder: (BuildContext ctx, int index){
                  CartDetailsModel details = _displayData!.carts[index];

                  if(details.comment == null){
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Slidable(
                        enabled: _enableSlidable,
                        endActionPane: ActionPane(
                          extentRatio: 0.30,
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              flex: 1,
                              onPressed: (_){
                                edit(
                                  context, 
                                  details.id,
                                  details.qty,
                                  details.comment.toString(),
                                  details.product,
                                  callback: (callback){
                                    setState(() {
                                      details.qty = callback.qty;
                                      details.product = callback.product;
                                      details.comment = callback.comment;
                                    });
                                  },

                                );
                              },
                              backgroundColor: Colors.greenAccent.shade400,
                              icon: Icons.mode_edit_rounded,
                            ),
                                  
                            SlidableAction(
                              onPressed: (_){
                                print(_displayData!.id);
                                delete(context, details.id, _displayData!.id);
                              },
                              backgroundColor: Colors.red,
                              icon: Icons.delete_rounded,
                            ),
                          ]
                        ),
     
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          color: Colors.grey.shade200,
                          height: 105,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 80,
                                height: 120,
                                child: details.product.images.isEmpty ? Image.asset(
                                  'assets/images/placeholder.jpg',
                                  fit: BoxFit.fitWidth
                                ) : Image.network("${Network.imageUrl}${details.product.images[0].url}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                      
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: Column(
                                  children: [
                                    const Center(
                                      child: SizedBox(
                                        width: 190,
                                        height: 30,
                                        child: Text('To Prepare',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255,40,84,232)
                                          ),
                                        ),
                                      ),
                                    ),
                            
                                    SizedBox(
                                      width: 190,
                                      height: 50,
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
                                  child: Text("P${details.product.price}",
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
                      ),
                    );                    
                  }

                  else{
                    return Padding(
                    
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Slidable(
                                  enabled: _enableSlidable,
                                  endActionPane: ActionPane(
                                    extentRatio: 0.30,
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        flex: 1,
                                        onPressed: (_){
                                          edit(
                                            context, 
                                            details.id,
                                            details.qty,
                                            details.comment.toString(),
                                            details.product,
                                            callback: (callback){
                                                setState(() {
                                                  details.qty = callback.qty;
                                                  details.product = callback.product;
                                                  details.comment = callback.comment;
                                                });
                                              },
                                          );
                                        },
                                        backgroundColor: Colors.greenAccent.shade400,
                                        icon: Icons.mode_edit_rounded,
                                      ),
                                  
                                      SlidableAction(
                                        onPressed: (_){
                                          print(_displayData!.id);
                                          delete(context, details.id, _displayData!.id);
                                        },
                                        backgroundColor: Colors.red,
                                        icon: Icons.delete_rounded,
                                      ),
                                    ]
                                  ),
     
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    color: Colors.grey.shade200,
                                    height: 150,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          height: 120,
                                          child: details.product.images.isEmpty ? Image.asset(
                                            'assets/images/placeholder.jpg',
                                            fit: BoxFit.fitWidth
                                          ) : Image.network("${Network.imageUrl}${details.product.images[0].url}",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                      
                                        Container(
                                          margin: const EdgeInsets.only(top: 5),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                       const Center(
                                                        child: SizedBox(
                                                          width: 190,
                                                          height: 30,
                                                          child: Text('To Prepare',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color.fromARGB(255,40,84,232)
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                            
                                                      SizedBox(
                                                        width: 190,
                                                        height: 40,
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

                                                  SizedBox(
                                                    width: 80,
                                                    height: 70,
                                                    child: Center(
                                                      child: Text("P${details.product.price}",
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),

                                              Container(
                                                width: 250,
                                                height: 50,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                  borderRadius: const BorderRadius.all (Radius.circular(10)),
                                                ),
                                                child: Text(details.comment.toString()),
                                              )

                                            ],
                                          ),
                                        ),

                                        

                                      ],
                                    ),
                                  ),
                                ),
                              );
                  }

                }, 
                separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.transparent), 
              ),

                        Container(
                          height: 60,
                          padding: const EdgeInsets.only(right: 20, top: 15),
                          margin: const EdgeInsets.only(bottom: 15, top: 20),
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
                                child: Text("${_displayData!.total}", 
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), 
                                  textAlign: TextAlign.end
                                )
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
                                SizedBox(
                                  width: size.width,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      side: const BorderSide(
                                        width: 3,
                                        color: Color.fromARGB(255, 40, 84, 232)
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:BorderRadius.circular(10)
                                      ),
                                      primary: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context, MaterialPageRoute(
                                          builder: (context) => ProductPage(
                                            isFromLocalPage: true,
                                            height: 630,
                                            cusid: _displayData?.customer?.id ?? 0,
                                            cusname: widget.cusname
                                          )
                                        )
                                      );
                                    },
                                    child: const Text('ADD ANOTHER PRODUCT',
                                      style: TextStyle(
                                        fontSize: 20,
                                        letterSpacing: 3,
                                        color: Color.fromARGB(255, 40, 84, 232)
                                      )
                                    ),
                                  )
                                ),

                                Visibility(
                                  visible: _disableConfirmButton,
                                  child: Container(
                                    width: size.width,
                                    margin: const EdgeInsets.only(top: 5),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        primary: const Color.fromARGB(255, 40, 84, 232),
                                        padding: const EdgeInsets.symmetric(vertical: 20),
                                      ),
                                      onPressed: widget.isfromPendingOrder == true ? (){} :
                                      () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                
                                        await _confirmOrder.confirm(
                                          cartcustomerId: _displayData!.id
                                        )
                                        .whenComplete(
                                          () => setState(
                                            () => isLoading = false,
                                          ),
                                        );
                                
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context, builder: (ctx) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15)
                                            ),
                                            content: SizedBox(
                                              width: 190,
                                              height: 138,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    margin: const EdgeInsets.only(bottom: 10),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        width: 5,
                                                        color: const Color.fromARGB(255, 40, 84, 232)
                                                      )
                                                    ),

                                                    child: const Icon(
                                                      Icons.check_rounded,
                                                      size: 35,
                                                      color: Color.fromARGB(255, 40, 84, 232)
                                                    ),
                                                  ),
                                
                                                  const Center(
                                                    child: Text("Order Successfully Added",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 20
                                                      )
                                                    ),
                                                  ),
                                
                                                  Container(
                                                    padding: const EdgeInsets.only(top: 10),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        TextButton(
                                                          onPressed: (){
                                                            Navigator.of(context).pushNamedAndRemoveUntil(
                                                              '/landingPage', (Route<dynamic> route) => false
                                                            );
                                                          }, 
                                                          child: const Text('Go Back to Home',
                                                            style: TextStyle(fontSize: 16)
                                                          )
                                                        ),
                                
                                                        TextButton(
                                                          onPressed: (){
                                                            Navigator.of(context).pop();
                                                          }, 
                                                          child: const Text('Continue', 
                                                            style: TextStyle(fontSize: 16)
                                                          )
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ]
                                              ),
                                            ),
                                          ),
                                        );
                                
                                        setState(() {
                                          _enableSlidable = !_enableSlidable;
                                          _disableConfirmButton = !_disableConfirmButton;
                                        });
                                      },
                                      child: const Text('CONFIRM ORDER',
                                        style: TextStyle(fontSize: 22, letterSpacing: 3)
                                      ),
                                    )
                                  ),

                                  replacement: Container(
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
                                                _change.text = (double.parse(_amount.text) - double.parse(_displayData!.total.toString())).toString();
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
                                      if(double.parse(_amount.text)  >= double.parse(_displayData!.total.toString())){
                                        setState(() {
                                          isLoading = true;
                                        });

                                        await _addPayment.payment(
                                          cartcustomerId: _displayData!.id,
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
                                                        
                                                        Text("Php ${_displayData!.total}",
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
                                                        const Text('Amount Received',
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
                                                
                                                        Text('Php ${_amount.text.isNotEmpty ? double.parse(_amount.text) - (_displayData!.total.toString().isNotEmpty ? double.parse(_displayData!.total.toString()) : 0.0) : "0.0"}',
                                                          style: const TextStyle(fontSize:18)
                                                        ),
                                                      ],
                                                    ),

                                                  //   Container(
                                                  //     width: size.width,
                                                  //     height: 50,
                                                  //     margin: const EdgeInsets.only(top: 60),
                                                  //     child:ElevatedButton(
                                                  //       style: ElevatedButton.styleFrom(
                                                  //         shape: RoundedRectangleBorder(
                                                  //           borderRadius: BorderRadius.circular(10)
                                                  //         ),
                                                  //       primary:const Color.fromARGB(255, 15, 41, 142)
                                                  //     ),

                                                  //     child: const Text('Go to Pending Orders',
                                                  //       style: TextStyle(
                                                  //         color: Colors.white,
                                                  //         fontSize: 20
                                                  //       )
                                                  //     ),

                                                  //     onPressed: () {
                                                  //       Navigator.push(
                                                  //         context, MaterialPageRoute(
                                                  //           builder: (context) => PendingOrderDetailsPage(
                                                  //             cusid: widget.cusid,
                                                  //             cusname: widget.cusname,
                                                  //           )
                                                  //         )
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
            ],
          ),
        ),
      )
    );
  }
}