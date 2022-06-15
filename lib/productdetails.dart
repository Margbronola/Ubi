// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:internapp/global/network.dart';
import 'package:internapp/model/cartdetails_model.dart';
import 'package:internapp/model/product_model.dart';
import 'package:internapp/orderdetails.dart';
import 'package:internapp/services/API/cartdetailsApi.dart';
import 'package:internapp/services/API/deleteupdateorder.dart';

// ignore: must_be_immutable
class ProductDetailsPage extends StatefulWidget {
  bool isFromWithoutCustomer;
  final ProductModel product;
  final ValueChanged<CartDetailsModel> onUpdateCallback;
  bool isfromOrderDetails;
  int quantity;
  int cusid;
  String comment;
  String cusname;
  int cartId;
  
  ProductDetailsPage({Key? key,  
    this.isFromWithoutCustomer = false,
    required this.product, 
    required this.onUpdateCallback,
    this.quantity = 0, 
    this.cartId = 0, 
    this.isfromOrderDetails = false, 
    this.cusid = 0,
    required this.comment, 
    this.cusname = ""}) 
  : super(key: key);


  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late final TextEditingController comment =  TextEditingController()..text = widget.comment;
  final CartDetails order = CartDetails();
  final DeleteUpdateOrderCart _updateorder = DeleteUpdateOrderCart();
  bool visiblebutton = false;
  bool isLoading = false;
  String label = "Add Order";
  Color borderColor = const Color.fromARGB(255, 40, 84, 232); 

  int _qty = 1;

  void _addQty(){
    setState(() {
      if(widget.isfromOrderDetails == true){
        widget.quantity++;
      }

      else{
        _qty++;
      }
    });
  }

  void _minusQty(){
    setState(() {
      if(widget.isfromOrderDetails == true){
        if(widget.quantity > 1){
          widget.quantity--;
        }
        else{
          widget.quantity;
        }
      }

      else{
        if(_qty > 1){
          _qty--;
        }
        else{
          _qty;
        }
      }
      
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: const Color.fromARGB(255, 40, 84, 232),
          backgroundColor: Colors.white,
          elevation: 0,
          // actions: [
          //   IconButton(
          //     padding: const EdgeInsets.only(right: 25),
          //     onPressed: (){
          //       Navigator.push(
          //         context, MaterialPageRoute(
          //           builder: (context) => const CartPage()
          //         )
          //       );
          //     },
    
          //     icon: Stack(
          //       children: [
          //         const Icon(Icons.shopping_cart_outlined),
          //         Positioned(
          //           top: 0,
          //           right: 0,
          //           child: Container(
          //             height: 13,
          //             width: 13,
          //             alignment: Alignment.center,
          //             decoration: const BoxDecoration(
          //               shape: BoxShape.circle,
          //               color: Color.fromARGB(255, 232, 149, 40)
          //             ),
          //             child: const Text('3', style: TextStyle(color: Colors.white))
          //           )
          //         )
          //       ],
          //     ),
          //     color: const Color.fromARGB(255, 232, 149, 40),
          //   )
          // ]
        ),

        body: SafeArea(
          child: Container(
            width: size.width,
            height: size.height,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            child: Container(
              color: Colors.white,
              child: ListView(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 280,
                        child: Column(
                          children: [
                            Hero(
                              tag: "product",
                              child: SizedBox(
                                width: 400,
                                height: 245,
                                child: widget.product.images.isEmpty ? Image.asset('assets/images/placeholder.jpg', fit: BoxFit.fitWidth) : Image.network(
                                "${Network.imageUrl}${widget.product.images[0].url}",
                                fit: BoxFit.cover,
                                )
                              ),
                            ),
    
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              color: const Color.fromARGB(255, 232, 149, 40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.product.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
    
                                  Text(widget.product.price.toStringAsFixed(2),
                                    style: const TextStyle(
                                      color: Colors.white, fontSize: 20
                                    )
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (widget.product.stock == 0) ...{
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(.4),
                            alignment: Alignment.center,
                            child: const Text('Out of Stock',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                letterSpacing: 5
                              ),
                            ),
                          )
                        )
                      },
                    ],
                  ),
    
                  Container(
                    width: size.width,
                    height: 160,
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Product Details',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          )
                        ),
    
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                          child: Text(widget.product.description??"",
                            style: const TextStyle(color: Colors.black, fontSize: 17)
                          ),
                        ),
                      ],
                    ),
                  ),
    
                  Column(
                    children: [
                      Container(
                        width: size.width,
                        height:175,
                        margin: const EdgeInsets.only(top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Request and Add-ons", style: TextStyle(fontSize: 18)),
                            TextFormField(
                              enabled: label == "Added" ? false : true,
                              controller: comment,
                              maxLines: 7,
                              decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromARGB(255, 40, 84, 232), width: 2),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromARGB(255, 40, 84, 232), width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Add request here"
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: size.width,
                        height: 70,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 175,
                              height: 50,
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    margin: const EdgeInsets.only(right: 7),
                                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
                                    color: Color.fromARGB(255, 40, 84, 232)),
                                    child: IconButton(
                                      padding: const EdgeInsets.all(5),
                                      alignment: Alignment.topCenter,
                                      onPressed: (){
                                        if(label == "Added"){
                                          return;
                                        }
                                        else{
                                          setState(() {
                                            _minusQty();
                                          });
                                        }
                                      },
                                      icon: const Icon(Icons.minimize_rounded, color: Colors.white),
                                    ),
                                  ),
          
                                  Container(
                                    width: 60,
                                    height: 50,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(right: 7),
                                    child: Text('${widget.quantity == 0 ? _qty : widget.quantity}',
                                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                    )
                                    // TextField(
                                    //   enabled: false,
                                    //   textAlign: TextAlign.center,
                                    //   keyboardType: TextInputType.number,
                                    //   controller: _qty,
                                    //   style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                    //   decoration: const InputDecoration(
                                    //     focusedBorder: OutlineInputBorder(
                                    //       borderSide: BorderSide(color: Color.fromARGB(255, 40, 84, 232), width: 2),
                                    //     ),
                                    //     border: OutlineInputBorder(
                                    //       borderSide: BorderSide(color: Color.fromARGB(255, 40, 84, 232), width: 5),
                                    //     ),
                                    //   filled: true,
                                    //   fillColor: Colors.white,
                                    //   ),
                                    // ),
                                  ),
          
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
                                    color: Color.fromARGB(255, 40, 84, 232)),
                                    child: IconButton(
                                      padding: const EdgeInsets.all(12),
                                      alignment: Alignment.topCenter,
                                      onPressed: (){
                                        if(label == "Added"){
                                          return;
                                        }
                                        else{
                                          setState(() {
                                            _addQty();
                                          });
                                        }
                                      },
                                      icon: const Icon(Icons.add_rounded, color: Colors.white),
                                    ),
                                  ),
                                ]
                              ),
                            ),
          
                            if(widget.isfromOrderDetails )...{
                                SizedBox(
                                  width: 150,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () async{
                                      setState(() {
                                        isLoading = true;
                                      
                                      });

                                      await _updateorder.update(
                                        cartID: widget.cartId,
                                        qty: widget.quantity,
                                        comment: comment.text
                                      ).then((value) {
                                        if(value != null){
                                          print("HAS VALUE");
                                          print("QUANTITY: ${value.qty}");
                                          widget.onUpdateCallback(value);
                                        }
                                        setState(() {});
                                      }).whenComplete(
                                        () => setState(
                                          () => isLoading = false,
                                        ),
                                      );
                                      
                                        Navigator.of(context).pop();
                                      
                                    },
                                  
                                    child: const Text("Update", 
                                      style: TextStyle(fontSize: 20, color: Colors.white)
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      primary: borderColor
                                    ),
                                  ),
                                )
                              }

                              else...{
                                SizedBox(
                                width: 150,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async{
                                      if(label == "Added"){
                                        return;
                                      }
                                      else{
                                        if(widget.product.stock < _qty){
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25)
                                              ),
                                              title: const Text(""),
                
                                              content: Text("Order quantity exceeds stock!\n\n Available Stock :  ${widget.product.stock}", 
                                                textAlign: TextAlign.center, style: const TextStyle(fontSize: 17),
                                              ),

                                              actions: <Widget>[
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: const Text("Close"),
                                                )
                                              ]
                                            ),
                                          );
                                        }
                                        else{
                                          setState(() {
                                            isLoading = true;
                                          });
                                    
                                          await order.addOrder(
                                            comment: comment.text,
                                            productid: widget.product.id,
                                            quantity: _qty,
                                            customerID: widget.cusid, 
                                          ).then((value){
                                            order.getOrderDetailsbyCustomer(customerId: widget.cusid);
                                          }).whenComplete(
                                            () => setState(
                                              () => isLoading = false,
                                            ),
                                          );
                                    
                                          setState(() {
                                            visiblebutton = !visiblebutton;
                                            label = "Added";
                                            borderColor = const Color.fromARGB(255, 232, 149, 40);
                                          });
                                        }   
                                      }                        
                                  },
                                
                                  child: Text(label, 
                                    style: const TextStyle(fontSize: 20, color: Colors.white)
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    primary: borderColor
                                  ),
                                ),
                              )
                            },
                          ],
                        )
                      ),

                    ],
                  ),    
    
                  Expanded(
                    child: Visibility(
                      visible: visiblebutton,
                      child: Container(
                        height: 180,
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            SizedBox(
                              width: size.width,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  side: const BorderSide(width: 2, color: Color.fromARGB(255, 40, 84, 232)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  primary: Colors.white
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('ADD ANOTHER PRODUCT', 
                                  style: TextStyle(
                                    fontSize: 20, 
                                    letterSpacing: 3, 
                                    color: Color.fromARGB(255, 40, 84, 232)
                                  )
                                )
                              ),
                            ),
    
                              Container(
                                width: size.width,
                                height: 55,
                                margin: const EdgeInsets.only(top: 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    side: const BorderSide(width: 3, color: Color.fromARGB(255, 40, 84, 232)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    primary: const Color.fromARGB(255, 40, 84, 232)
                                  ),

                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context, MaterialPageRoute(
                                        builder: (context) => OrderDetailsPage(
                                          product: widget.product,
                                          cusid: widget.cusid,
                                          cusname: widget.cusname,
                                          isfromPendingOrder: false,
                                        )
                                      )
                                    );
                                  },
                                  child: const Text('FINISH ORDER', 
                                    style: TextStyle(fontSize: 20, letterSpacing: 5, color: Colors.white),
                                  )
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}