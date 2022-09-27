import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:internapp/global/app.dart';
import 'package:internapp/global/network.dart';
import 'package:internapp/model/product_model.dart';
import 'package:internapp/productdetails.dart';
import 'package:internapp/profile_page.dart';
import 'package:internapp/viewmodel/productviewmodel.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';

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
            child: Column(
              children: [
                Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 15.0,
                        offset: const Offset(0.0, 0.75)
                      )
                    ]
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:BorderSide(color: Colors.grey.shade300),
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
                
                Expanded(
                  child: Container(
                    width: size.width,
                    padding:const EdgeInsets.symmetric(horizontal: 20),
                    margin: const EdgeInsets.only(top: 15, bottom: 70),
                    child: StreamBuilder<List<ProductModel>>(
                      stream: _viewModel.stream,
                      builder: (_, snapshot) {
                        if (snapshot.hasData && !snapshot.hasError) {
                          if (snapshot.data!.isNotEmpty) {
                            final List<ProductModel> searchProduct = snapshot.data!.where((element) => element.name.toLowerCase().contains(searchString)).toList();
                            
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
                                  return LayoutBuilder(
                                    builder: (context,c) {
                                      final double w = c.maxWidth;
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context, PageTransition(
                                              type: PageTransitionType.rightToLeftWithFade,
                                              child: ProductDetailsPage(
                                                onUpdateCallback: (callback){},
                                                product: searchProduct[index],
                                                comment: "",
                                                cusid: widget.cusid,
                                              ),
                                            )
                                          );
                                        },
                
                                        child: Stack(
                                          children: [
                                            Column(
                                              children: [
                                                Expanded(
                                                  child: Hero(
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
                                                ),
                
                                                Container(
                                                  width: w,
                                                  padding:const EdgeInsets.all(5),
                                                  color: const Color.fromARGB(255, 232, 149, 40),
                                                  child: Wrap(
                                                    crossAxisAlignment: WrapCrossAlignment.center,
                                                    runAlignment: WrapAlignment.spaceBetween,
                                                    alignment: WrapAlignment.spaceBetween,
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
                                          )
                                        )
                                      );
                                    },
                
                                    child: Container(
                                      color: Colors.grey.shade300,
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
                                                    fontSize: 19
                                                  ),
                                                ),
                                              )
                                            )
                                          },
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.transparent),
                              );
                            }
                          }
                
                          return const Center(
                            child: Text('No Product entry', style: TextStyle(fontSize: 25))
                          );
                        }
                        
                        return Center(
                          child: LoadingAnimationWidget.prograssiveDots(
                            color: const Color.fromARGB(255, 40, 84, 232), 
                            size: 50
                          )
                        );
                      }
                    ),
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