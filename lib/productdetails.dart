// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:internapp/cartdetails.dart';
import 'package:internapp/global/network.dart';
import 'package:internapp/model/addtocart_model.dart';
import 'package:internapp/model/cartdetails_model.dart';
import 'package:internapp/model/product_model.dart';
import 'package:internapp/services/API/cartApi.dart';
import 'package:internapp/services/API/deleteupdateorder.dart';
import 'package:page_transition/page_transition.dart';

// ignore: must_be_immutable
class ProductDetailsPage extends StatefulWidget {
  final ProductModel product;
  final ValueChanged<CartDetailsModel> onUpdateCallback;
  bool isfromOrderDetails;
  int quantity;
  int? cusid;
  String comment;
  int cartId;
  
  ProductDetailsPage({Key? key,  
    required this.product, 
    required this.onUpdateCallback,
    this.quantity = 0, 
    this.cartId = 0, 
    this.isfromOrderDetails = false, 
    this.cusid,
    required this.comment,
  }) 
  : super(key: key);


  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late final TextEditingController comment =  TextEditingController()..text = widget.comment;
  AddToCartModel? added;
  final DeleteUpdateOrderCart _updateorder = DeleteUpdateOrderCart();
  final CartApi cartApi = CartApi();
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
                padding: const EdgeInsets.symmetric(vertical: 0),
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                
                                  Text(widget.product.price.toStringAsFixed(2),
                                    style: const TextStyle(
                                      color: Colors.white, 
                                      fontSize: 17
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
                        padding: const EdgeInsets.only(top: 15, bottom: 20),
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
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(widget.product.description ?? "",
                                style: const TextStyle(color: Colors.black, fontSize: 17)
                              ),
                            ),
                          ],
                        ),
                      ),
                
                      Column(
                        children: [
                          SizedBox(
                            width: size.width,
                            height:160,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Request and Add-ons", 
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                ),
                                Expanded(
                                  child: TextFormField(
                                    enabled: label == "Added" || widget.product.stock == 0 ? false : true,
                                    controller: comment,
                                    maxLines: 5,
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
                                    onTap: (){
                                      comment.clear();
                                    },
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
                                  width: 170,
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
                                        color: Color.fromARGB(255, 40, 84, 232)),
                                        child: IconButton(
                                          padding: const EdgeInsets.all(5),
                                          alignment: Alignment.topCenter,
                                          onPressed: (){
                                            if(label == "Added" || widget.product.stock == 0){
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
                                        child:Text('${widget.quantity == 0 ? _qty : widget.quantity}',
                                          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                                            if(label == "Added" || widget.product.stock == 0){
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
                                    // width: 150,
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
                                  Expanded(
                                    child: SizedBox(
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
                      
                                                  content: Text("Order quantity exceeds stock!\n Available Stock :  ${widget.product.stock}", 
                                                    textAlign: TextAlign.center,
                                                  ),
            
                                                  actions: <Widget>[
                                                    MaterialButton(
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
                                            
                                              await cartApi.addToCart(
                                                comment: comment.text,
                                                productid: widget.product.id,
                                                quantity: _qty,
                                                customerID: widget.cusid == 0 ? null : widget.cusid, 
                                              ).then((value){
                                                if(value != null){
                                                  setState(() {
                                                    added = value;
                                                  });
                                                  cartApi.getCartDetails(cartCustomerId: value.cartcustomer!.id);
                                                }
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
                                          style: const TextStyle(fontSize: 18, color: Colors.white)
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          primary: borderColor
                                        ),
                                      ),
                                    ),
                                  )
                                }
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
                                  ),
                                  textAlign: TextAlign.center,
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
            
                                onPressed: added != null ? () {
                                  Navigator.pushReplacement(
                                    context, PageTransition(
                                      type: PageTransitionType.rightToLeftWithFade,
                                      child: CartDetailsPage(
                                        product: widget.product,
                                        cusname: added!.cartcustomer?.customer?.name ?? "N/A",
                                        isfromPendingOrder: false,
                                        cartcusid: added!.cartcustomer!.id
                                      ),
                                    )
                                  );
                                } : null,
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
            )
          ),
        ),
      ),
    );
  }
}