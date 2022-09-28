import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:internapp/global/network.dart';
import 'package:internapp/model/product_model.dart';
import 'package:internapp/productdetails.dart';
import 'package:internapp/viewmodel/productviewmodel.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class OutofStockPage extends StatefulWidget {
  const OutofStockPage({ Key? key }) : super(key: key);

  @override
  State<OutofStockPage> createState() => _OutofStockPageState();
}

class _OutofStockPageState extends State<OutofStockPage> {
  final ProductViewModel _viewModel = ProductViewModel.instance;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          color: Colors.white,
          padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
          child: StreamBuilder<List<ProductModel>>(
            stream: _viewModel.stream,
            builder: (_, snapshot) {
              if(snapshot.hasData && !snapshot.hasError){
                if (snapshot.data!.isNotEmpty){
                  final List<ProductModel> _outOfStockProducts = snapshot.data!.where((element) => element.stock == 0).toList();
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _outOfStockProducts.length,
                    itemBuilder: (BuildContext ctx, int index){
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context, MaterialPageRoute(
                              builder: (context) => ProductDetailsPage(
                                onUpdateCallback: (callback){},
                                comment: "",
                                product: _outOfStockProducts[index],
                              )
                            )
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          color: Colors.grey.shade200,
                          height: 130,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // ClipRRect(
                              //   borderRadius: BorderRadius.circular(100),
                              //   child: SizedBox(
                              //     width: 100,
                              //     height: 100,
                              //     child: _outOfStockProducts[index].images.isEmpty ? 
                              //     Image.asset('assets/images/placeholder.jpg', fit: BoxFit.cover) : 
                              //     Image.network("${Network.imageUrl}${_outOfStockProducts[index].images[0].url}",
                              //       fit: BoxFit.cover
                              //     ),
                              //   ),
                              // ),

                              SizedBox(
                                width: 100,
                                height: 100,
                                child: CachedNetworkImage(
                                  imageUrl: "${Network.imageUrl}${_outOfStockProducts[index].images[0].url}",
                                  imageBuilder: (context, imageProvider) => CircleAvatar(
                                    radius: 50,
                                    backgroundImage: imageProvider,
                                  ),
                                  placeholder: (context, url) => Container(
                                    alignment: Alignment.center,
                                    child: LoadingAnimationWidget.twoRotatingArc(color: const Color.fromARGB(255, 40, 84, 232), size: 40),
                                  ),
                                  errorWidget: (context, url, error) => Image.asset("assets/images/placeholder.jpg"),
                                ),
                              ),
                        
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(_outOfStockProducts[index].name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.transparent),
                  );
                }

                return const Center(
                  child: Text('No Out of Stock Product',
                    style: TextStyle(
                      fontSize: 20, 
                      letterSpacing: 2
                    )
                  )
                );

              }
              return Center(
                child: LoadingAnimationWidget.prograssiveDots(
                  color: const Color.fromARGB(255, 40, 84, 232), 
                  size: 50
                ),
              );
            },
          ),
        )
      ),
    );
  }
}