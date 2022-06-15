import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:internapp/global/app.dart';
import 'package:internapp/global/network.dart';
import 'package:internapp/model/product_model.dart';
import 'package:internapp/productdetails.dart';
import 'package:internapp/profile_page.dart';
import 'package:internapp/services/API/categoryApi.dart';
import 'package:internapp/viewmodel/productviewmodel.dart';

// ignore: must_be_immutable
class ProductPage extends StatefulWidget {
  ProductPage(
    {Key? key,
      this.isFromWithoutCustomer = false,
      this.isFromLocalPage = false,
      this.height = 638,
      this.cusid = 0,
      this.cusname = ""})
    : super(key: key);

  bool isFromWithoutCustomer;
  bool isFromLocalPage;
  double height;
  int cusid;
  String cusname;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ProductViewModel _viewModel = ProductViewModel.instance;
  final CategoryAPI categoryAPI = CategoryAPI();
  final TextEditingController controller = TextEditingController();
  String searchString = "";

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: widget.isFromLocalPage ? AppBar(
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
        ) : null,

        body: SizedBox(
          width: size.width,
          height: size.height,
          child: SafeArea(
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: size.width,
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchString = value.toLowerCase();
                            });
                          },
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            hintText: 'Search Product',
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            suffixIconConstraints: const BoxConstraints(
                              maxHeight: double.maxFinite,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                            suffixIcon: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 40, 84, 232),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                              child: const Icon(Icons.search_rounded,
                                color: Colors.white),
                            )
                          ),
                        ),
                      ),

                      // IconButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context, MaterialPageRoute(
                      //         builder: (context) => const CartPage()
                      //       )
                      //     );
                      //   },
                    
                      //   icon: Stack(
                      //     children: [
                      //       const Icon(Icons.shopping_cart_outlined),
                      //       Positioned(
                      //         top: 0,
                      //         right: 0,
                      //         child: Container(
                      //           height: 13,
                      //           width: 13,
                      //           alignment: Alignment.center,
                      //           decoration: const BoxDecoration(
                      //             shape: BoxShape.circle,
                      //             color: Color.fromRGBO(194, 116, 15, 1)
                      //           ),
                      //           child: const Text('3',
                      //             style: TextStyle(color: Colors.white)
                      //           )
                      //         )
                      //       )
                      //     ],
                      //   ),
                      //   color: const Color.fromARGB(255, 232, 149, 40),
                      // ),

                      IconButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          setState(() {
                            isGridView = !isGridView;
                          });
                        },
              
                        icon: Icon(
                          isGridView ? Icons.list_rounded : Icons.dashboard,
                          color: const Color.fromARGB(255, 40, 84, 232),
                          size: 30,
                        )
                      ),

                    ],
                  ),
                ),

                // Container(
                //   height: 50,
                //   width: size.width,
                //   margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Expanded(
                //         child: Container(
                //           decoration: BoxDecoration(
                //             borderRadius:
                //                 const BorderRadius.all(Radius.circular(10)),
                //             color: Colors.grey.shade300,
                //           ),
                //           height: 65,
                //         ),
                //       ),
                      
                //       IconButton(
                //           padding: const EdgeInsets.all(0),
                //           onPressed: () {
                //             setState(() {
                //               isGridView = !isGridView;
                //             });
                //           },
                //           icon: Icon(
                //             isGridView ? Icons.list_rounded : Icons.dashboard,
                //             color: const Color.fromARGB(255, 40, 84, 232),
                //             size: 25,
                //           )),
                //     ],
                //   ),
                // ),

                Container(
                  height: widget.height,
                  padding:const EdgeInsets.only(left: 20, right: 20),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: StreamBuilder<List<ProductModel>>(
                    stream: _viewModel.stream,
                    builder: (_, snapshot) {
                      if (snapshot.hasData && !snapshot.hasError) {
                        if (snapshot.data!.isNotEmpty) {
                          final List<ProductModel> searchProduct = snapshot.data!.where((element) => element.name
                          .toLowerCase().contains(searchString)).toList();
            
                          if (isGridView) {
                            return GridView.builder(
                              shrinkWrap: true,
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                mainAxisExtent: 230,
                                childAspectRatio: 3 / 2,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15
                              ),
                                  
                              itemCount: searchProduct.length,
                              itemBuilder: (BuildContext ctx, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context, MaterialPageRoute(
                                        builder: (context) => ProductDetailsPage(
                                          isFromWithoutCustomer: widget.isFromWithoutCustomer,
                                          onUpdateCallback: (callback){},
                                          product: searchProduct[index],
                                          comment: "",
                                          cusid: widget.cusid,
                                          cusname: widget.cusname,
                                        )
                                      )
                                    );
                                  },

                                  child: Stack(
                                    children: [
                                      Column(
                                        children: [
                                          Hero(
                                            tag: "product",
                                            child: SizedBox(
                                              width: 200,
                                              height: 200,
                                                child: SizedBox(
                                                  width: 200,
                                                  height: 200,
                                                  child: searchProduct[index].images.isEmpty ? SizedBox(
                                                    width: 200,
                                                    height: 200,
                                                    child: Image.asset('assets/images/placeholder.jpg',
                                                      fit: BoxFit.fitWidth
                                                    ),
                                                  ) : Image.network(
                                                    "${Network.imageUrl}${searchProduct[index].images[0].url}",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                            ),

                                            Container(
                                              padding:const EdgeInsets.all(5),
                                              color: const Color.fromARGB(255, 232, 149, 40),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(searchProduct[index].name,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold
                                                    )
                                                  ),

                                                  Text(searchProduct[index].price.toStringAsFixed(2),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize:20
                                                    )
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                        if (searchProduct[index].stock == 0) ...{
                                          Positioned.fill(
                                            child: Container(
                                              color: Colors.black.withOpacity(.4),
                                              alignment: Alignment.center,
                                              child: const Text('Out of Stock',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25,
                                                ),
                                              ),
                                            )
                                          )
                                        },
                                      ],
                                    ),
                                  );
                                }
                              );
                            } 
                            
                            else {
                              return ListView.separated(
                                shrinkWrap: true,
                                itemCount: searchProduct.length,
                                itemBuilder: (BuildContext ctx, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context, MaterialPageRoute(
                                          builder: (context) => ProductDetailsPage(
                                            onUpdateCallback: (callback){},
                                            comment: "",
                                            product: searchProduct[index],
                                            cusid: widget.cusid,
                                            cusname: widget.cusname,
                                          )
                                        )
                                      );
                                    },

                                    child: Stack(
                                      children: [
                                        ListTile(
                                          title: Text(searchProduct[index].name,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                            )
                                          ),

                                          trailing: Text(searchProduct[index].price.toStringAsFixed(2),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20
                                            )
                                          ),
                                        ),

                                        if (searchProduct[index].stock == 0) ...{
                                          Positioned.fill(
                                            child: Container(
                                              color: Colors.black.withOpacity(.3),
                                              alignment: Alignment.center,
                                              child: const Text( 'Out of Stock',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22
                                                ),
                                              ),
                                            )
                                          )
                                        },
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.transparent),
                              );
                            }
                          }

                          return const Center(
                            child: Text('No Product entry', style: TextStyle(fontSize: 30))
                          );
                        }
                      return const Center(child: CircularProgressIndicator.adaptive());
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
