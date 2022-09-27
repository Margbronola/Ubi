import 'package:flutter/material.dart';
import 'package:internapp/global/network.dart';
import 'package:internapp/model/producttoprepare_model.dart';
import 'package:internapp/services/API/producttoprepareApi.dart';
import 'package:internapp/viewmodel/producttoprepareviewmodel.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProductsToPreparePage extends StatefulWidget {
  const ProductsToPreparePage({ Key? key }) : super(key: key);

  @override
  State<ProductsToPreparePage> createState() => _ProductsToPreparePageState();
}

class _ProductsToPreparePageState extends State<ProductsToPreparePage> {
  final ProductToPrepareViewModel _viewModel = ProductToPrepareViewModel.instance;
  bool isLoading = false;
  final ProductToPrepareAPI _toPrepareAPI = ProductToPrepareAPI();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 50),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        _toPrepareAPI.getToPrepare();
                      });
                    },
                    child: SizedBox(
                      width: size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Icon(Icons.refresh_rounded),
                          Text("Refresh", 
                            style: TextStyle(
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(
                    margin: const EdgeInsets.only(top: 15, bottom: 70),
                      child: StreamBuilder<List<ProductToPrepareModel>>( 
                        stream: _viewModel.stream,
                        builder: (_, snapshot) {
                          if(snapshot.hasData && !snapshot.hasError){
                            if(snapshot.data!.isNotEmpty){
                              final List<ProductToPrepareModel> _toPrepare = snapshot.data!.where((element) => !element.prepared).toList();
                              
                              return ListView.separated(
                                padding: const EdgeInsets.symmetric(vertical: 0),
                                itemCount: _toPrepare.length,
                                itemBuilder: (_, index){
                                  final ProductToPrepareModel model = _toPrepare[index];
                                  return Container(
                                    padding: const EdgeInsets.all(10),
                                      color: Colors.grey.shade200,
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:  BorderRadius.circular(80),
                                            child: SizedBox(
                                              width: 80,
                                              height: 80,
                                              child: model.products.images.isEmpty ? 
                                              Image.asset('assets/images/placeholder.jpg', fit: BoxFit.cover) : 
                                              Image.network("${Network.imageUrl}${model.products.images[0].url}",
                                                fit: BoxFit.cover
                                              ),
                                            ),
                                          ),

                                          const SizedBox(
                                            width: 15,
                                          ),
                                          
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("${model.qty}x",
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold
                                                        )
                                                      ),
                  
                                                      const SizedBox(
                                                        width: 15,
                                                      ),
                  
                                                      Expanded(child: Text(snapshot.data![index].products.name,
                                                        textAlign: TextAlign.left,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold
                                                        )
                                                      ),)
                  
                                                  ],
                                                ),
                                                
                                                const SizedBox(
                                                  height: 5,
                                                ),
                  
                                                if(model.comment != null) ...{
                                                  Text(model.comment!,
                                                    style: TextStyle(
                                                      color: Colors.grey.shade700,
                                                    ),
                                                  )
                                                }
                                              ],
                                            ) 
                                          ),
                  
                                          TextButton(
                                              onPressed: () async{
                                                setState(() {
                                                  isLoading = true;
                                                });
                              
                                                await _toPrepareAPI.markPrepared(
                                                  preparedID: model.id
                                                ).then((value) async{
                                                  setState(() {
                                                    _toPrepareAPI.getToPrepare();
                                                  });
                                                }).whenComplete(
                                                  () => setState(
                                                    () => isLoading = false,
                                                  ),
                                                );
                                              }, 
                            
                                              child: const Text("Serve",
                                                style: TextStyle(
                                                  color: Color.fromARGB(255, 40, 84, 232),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold
                                                ),
                                                textAlign: TextAlign.center
                                              )
                                            )
                                        ],
                                      ),
                                  );
                                }, 
                                separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.transparent), 
                              );
                            }
                            
                            return const Center(
                              child: Text('No Orders to Prepare',
                                style: TextStyle(fontSize: 20, letterSpacing: 1.5)
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
                    ),
                  ),
                ],
              ),
            ),
            isLoading ? Container(
              color: Colors.black38,
              width: size.width,
              height: size.height,
              child: Center(
                child: LoadingAnimationWidget.prograssiveDots(color: const Color.fromARGB(255, 40, 84, 232), size: 50),
              ),
            ): Container()
          ]
        ),
      ),
    );
  }
}