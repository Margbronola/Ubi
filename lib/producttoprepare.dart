import 'package:flutter/material.dart';
import 'package:internapp/global/network.dart';
import 'package:internapp/model/producttoprepare_model.dart';
import 'package:internapp/services/API/producttoprepareApi.dart';
import 'package:internapp/viewmodel/producttoprepareviewmodel.dart';

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
        child: Container(
          width: size.width,
          height: size.height,
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 50),
          child: StreamBuilder<List<ProductToPrepareModel>>( 
            stream: _viewModel.stream,
            builder: (_, snapshot) {
              if(snapshot.hasData && !snapshot.hasError){
                if(snapshot.data!.isNotEmpty){
                  final List<ProductToPrepareModel> _toPrepare = snapshot.data!.where((element) => !element.prepared).toList();
                  
                  return ListView.separated(
                    itemCount: _toPrepare.length,
                    itemBuilder: (BuildContext ctx, int index){
                      if(snapshot.data![index].comment != null){
                        return Container(
                          padding: const EdgeInsets.all(10),
                          color: Colors.grey.shade200,
                          height: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 95,
                                height: 130,
                                child: snapshot.data![index].products.images.isEmpty ? 
                                SizedBox(
                                  width: 95,
                                  height: 130,
                                  child: Image.asset('assets/images/placeholder.jpg', fit: BoxFit.fitWidth),
                                ) : Image.network("${Network.imageUrl}${snapshot.data![index].products.images[0].url}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                        
                              SizedBox(
                                width: 200,
                                height: 145,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 45,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.only(left: 5),
                                          child:  Text(snapshot.data![index].qty.toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                            )
                                          ),
                                        ),

                                        Container(
                                          width: 150,
                                          height: 40,
                                          alignment: Alignment.center, 
                                          child: Text(snapshot.data![index].products.name,
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                            )
                                          ),
                                        ),

                                      ],
                                    ),

                                    Container(
                                      width: 200,
                                      height: 85,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: const BorderRadius.all (Radius.circular(10)),
                                      ),
                                      padding: const EdgeInsets.all(5),
                                      alignment: Alignment.center,
                                      child: Text(snapshot.data![index].comment.toString(),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                
                              SizedBox(
                                width: 65,
                                height: 150,
                                child: TextButton(
                                  onPressed: () async{
                                    setState(() {
                                      isLoading = true;
                                    });
  
                                    await _toPrepareAPI.markPrepared(
                                      preparedID: snapshot.data![index].id
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

                                  child: const Text("To\nPrepare",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 40, 84, 232),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                    ),
                                    textAlign: TextAlign.center
                                  )
                                )
                              ),

                            ],
                          ),
                        );
                      }

                      return Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.grey.shade200,
                        height: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 95,
                              height: 110,
                              child: snapshot.data![index].products.images.isEmpty ? SizedBox(
                                width: 95,
                                height: 110,
                                child: Image.asset('assets/images/placeholder.jpg', fit: BoxFit.fitWidth),
                              ) : Image.network(
                                "${Network.imageUrl}${snapshot.data![index].products.images[0].url}",
                                fit: BoxFit.cover,
                              ),
                            ),
                      
                            Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 60,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(left: 5),
                                  child:  Text(snapshot.data![index].qty.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                ),

                                Container(
                                  width: 150,
                                  height: 60,
                                  alignment: Alignment.center, 
                                  child: Text(snapshot.data![index].products.name,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                ),
                
                                SizedBox(
                                  width: 65,
                                  height: 150,
                                  child: TextButton(
                                    onPressed: () async{
                                      setState(() {
                                        isLoading = true;
                                      });
  
                                      await _toPrepareAPI.markPrepared(
                                        preparedID: snapshot.data![index].id
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

                                    child: const Text("To Prepare",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 40, 84, 232),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  )
                                ),

                              ],
                            ),
                          ]
                        )
                      );
                    }, 
                    separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.transparent), 
                  );
                }

                return const Center(
                  child: Text('No Orders to Prepare',
                    style: TextStyle(fontSize: 30)
                  )
                );
              }
              return const Center(child: CircularProgressIndicator.adaptive());
            },
          ),
        ),
      ),
    );
  }
}