import 'package:flutter/material.dart';
import 'package:internapp/model/order_model.dart';
import 'package:internapp/orderdetails.dart';
import 'package:internapp/viewmodel/orderviewmodel.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({ Key? key }) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final OrderViewModel _viewModel = OrderViewModel.instance;
  final TextEditingController controller = TextEditingController();
  String searchString = "";

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          width: size.width,
          height: size.height,
          color: Colors.white,
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 15.0,
                      offset: const Offset(0.0, 0.75)
                    )
                  ]
                ),
                height: 120,
                child: Column(
                  children: [
                    Container(
                      width: size.width,
                      height: 55,
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchString = value.toLowerCase();
                            });
                          },

                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:BorderSide(color: Colors.grey.shade300),
                            ),
                            hintText: 'Search Customer',
                            hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            suffixIconConstraints: const BoxConstraints(
                              maxHeight: double.maxFinite,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                            suffixIcon:  Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 40, 84, 232),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
      
                              child: const Icon(Icons.search_rounded, color: Colors.white),
                            )
                          ),
                        ),
                      ),
                    ),

                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          SizedBox(
                            width: 125,
                            child: Center(
                              child: Text('Customer', 
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                              ),
                            )
                          ),
          
                          SizedBox(
                            width: 125,
                            child: Center(
                              child: Text('Amount', 
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                              ),
                            )
                          ),
          
                          SizedBox(
                            width: 125,
                            child: Center(
                              child: Text('Date', 
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                              ),
                            )
                          )
                        ],
                      ),
                    ),

                  ],
                )
              ),
    
              Container(
                height: 590,
                margin: const EdgeInsets.only(top: 15),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: StreamBuilder<List<OrderModel>>(
                  stream: _viewModel.stream,
                  builder: (_, snapshot) {
                    if (snapshot.hasData && !snapshot.hasError){
                      if (snapshot.data!.isNotEmpty) {
                        final List<OrderModel> searchCustomer = snapshot.data!.where((element) => element.cartcustomer?.customer?.name.toLowerCase().contains(searchString)??searchString.isEmpty).toList();
                        
                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: searchCustomer.length,
                          itemBuilder: (BuildContext ctx, int index ){
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context, MaterialPageRoute(
                                    builder: (context) => OrderDetailsPage(
                                      isfromPendingOrder: true,
                                      cusid: searchCustomer[index].cartcustomer?.customer?.id ?? 0,
                                      cusname: searchCustomer[index].cartcustomer?.customer?.name ?? "N/A",
                                      orderid: searchCustomer[index].id,
                                      status: searchCustomer[index].status ? "Paid" : "Pending",
                                    )
                                  )
                                );
                              },

                              child: Container(
                                color: Colors.grey.shade100,
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                      SizedBox(
                                        width: 125,
                                        child: Center(
                                          child: Text(searchCustomer[index].cartcustomer!.customer?.name ?? "N/A",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            )
                                          ),
                                        ),
                                      ),
                                    
                                      SizedBox(
                                        width: 125,
                                        child: Center(
                                          child: Text(searchCustomer[index].total.toStringAsFixed(2),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            )
                                          ),
                                        ),
                                      ),
                                    
                                      SizedBox(
                                        width: 125,
                                        child: Center(
                                          child: Text(DateFormat('MM-dd-yyyy').format(searchCustomer[index].date),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
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
                        child: Text('No Order',
                          style: TextStyle(fontSize: 30)
                        )
                      );
                      
                    }
                    return const Center(child: CircularProgressIndicator.adaptive());
                  }
                )
                        
              ),
            ],
          ),
        ),
      ),
    );
  }
}