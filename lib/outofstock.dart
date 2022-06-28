import 'package:flutter/material.dart';
import 'package:internapp/global/network.dart';
import 'package:internapp/model/product_model.dart';
import 'package:internapp/viewmodel/productviewmodel.dart';

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
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _outOfStockProducts.length,
                    itemBuilder: (BuildContext ctx, int index){
                      return 
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context, MaterialPageRoute(
                      //         builder: (context) => ProductPage(isFromLocalPage: true, height: 700)
                      //       )
                      //     );
                      //   },
                        
                      //   child:
                        Container(
                          padding: const EdgeInsets.all(15),
                          color: Colors.grey.shade300,
                          height: 130,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 140,
                                height: 125,
                                child:  _outOfStockProducts[index].images.isEmpty ? SizedBox(
                                  width: 140,
                                  height: 125,
                                  child: Image.asset('assets/images/placeholder.jpg', fit: BoxFit.fitWidth),
                                ) : Image.network("${Network.imageUrl}${_outOfStockProducts[index].images[0].url}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                      
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Center(
                                    child: Text(_outOfStockProducts[index].name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                      )
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      // );
                    },
                    separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.transparent),
                  );
                }

                return const Center(
                  child: Text('No Out of Stock Product',
                    style: TextStyle(fontSize: 30)
                  )
                );

              }
              return const Center(child: CircularProgressIndicator.adaptive());
            },
          ),
        )
      ),
    );
  }
}