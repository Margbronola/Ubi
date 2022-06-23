// ignore_for_file: avoid_print

import 'dart:ui';
import 'package:internapp/model/displaycart_model.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/material.dart';
import 'package:internapp/productpage.dart';
import 'package:internapp/profile_page.dart';
import 'package:internapp/productdetails.dart';
import 'package:internapp/global/network.dart';
import 'package:internapp/model/cart_model.dart';
import 'package:internapp/model/product_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:internapp/model/cartdetails_model.dart';
import 'package:internapp/services/API/addpaymentApi.dart';
import 'package:internapp/services/API/cartdetailsApi.dart';
import 'package:internapp/services/API/confirmorderApi.dart';
import 'package:internapp/services/API/deleteupdateorder.dart';
import 'package:internapp/viewmodel/cartdetailsviewmodel.dart';

// ignore: must_be_immutable
class OrderDetailsPage extends StatefulWidget {
  OrderDetailsPage(
    {Key? key,
      required this.product,
      this.qty = 0,
      this.comment = "none",
      this.cusid = 0,
      this.cusname = "",
      this.isfromPendingOrder = false,
    }) : super(key: key);

  ProductModel product;
  int cusid;
  int qty;
  String comment;
  String cusname;
  bool isfromPendingOrder;

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final CartDetailsViewModel _viewModel = CartDetailsViewModel.instance;
  final DeleteUpdateOrderCart _deleteorder = DeleteUpdateOrderCart();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _change = TextEditingController();
  final ConfirmOrder _confirmOrder = ConfirmOrder();
  final AddPayment _addPayment = AddPayment();
  final CartDetails _order = CartDetails();
  bool _disableConfirmButton = true;
  bool visiblecontainer = true;
  bool _enableSlidable = true;
  bool visiblewidget = false;
  bool isLoading = false;
  

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    DateTime current = DateTime.now();
    String date = Jiffy(current).format('MMMM dd, yyyy');
    
    void edit(BuildContext context, int cartId, int qty, String comment, ProductModel product, String cusname, {required ValueChanged<CartDetailsModel> callback,}) {
      Navigator.push(
        context, MaterialPageRoute(
          builder: (context) => ProductDetailsPage(
            onUpdateCallback: callback,
            cartId: cartId,
            quantity: qty,
            comment: comment,
            product: product,
            cusname: cusname,
            isfromOrderDetails: true,
          )
        )
      );
    }

    void delete(BuildContext context, int cartId, int cartCustomer) async{
      setState(() {
        isLoading = true;
      });

      await _deleteorder.delete(cartID: cartId)
      .then((value){
        setState(() {
          _order.getCartDetails(cartCustomerId: cartCustomer);
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
          child: ListView(
            children: [
              StreamBuilder<CartModel>(
                stream: _viewModel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && !snapshot.hasError) {
                    final TextEditingController _totalController = TextEditingController()..text = snapshot.data!.total.toString();
                    
                    return Column(
                      children: [
                        Container(
                          width: size.width,
                          height: 55,
                          margin: const EdgeInsets.only(top: 20, bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                  Text(snapshot.data!.customer?.name ?? "N/A",
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                                  ),
                                ],
                              ),
                            ]
                          ),
                        ),

                        SizedBox(
                          height: 450,
                          child: snapshot.data!.cart.isNotEmpty ? ListView.separated(
                            itemCount: snapshot.data?.cart.length ?? 0,
                            itemBuilder: (_, index) {
                              DisplayCartModel details = snapshot.data!.cart[index];
                              
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
                                              widget.cusname,
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
                                            print(snapshot.data!.id);
                                            delete(context, details.id, snapshot.data!.id);
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
                                            widget.cusname,
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
                                          print(snapshot.data!.id);
                                          delete(context, details.id, snapshot.data!.id);
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

                            },
                            separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.transparent),
                          ) : const Center(
                            child: Text('Empty Cart', style: TextStyle(fontSize: 25))
                          ) 
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
                                            cusid: widget.cusid,
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
                                          cartcustomerId: snapshot.data!.id
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
                                      if(double.parse(_amount.text)  >= double.parse(_totalController.text)){
                                        setState(() {
                                          isLoading = true;
                                        });

                                        await _addPayment.payment(
                                          cartcustomerId: snapshot.data!.id,
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
                                                
                                                        Text('Php ${_amount.text.isNotEmpty ? double.parse(_amount.text) - (_totalController.text.isNotEmpty ? double.parse(_totalController.text) : 0.0) : "0.0"}',
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
                        ),
                      ]
                    );
                  }
                  return Text(snapshot.error.toString());
                }
              ),
            ],
          ),
        ),
      )
    );
  }
}