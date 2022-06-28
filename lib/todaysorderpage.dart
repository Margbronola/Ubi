
// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:internapp/confirmorder.dart';
import 'package:internapp/model/order_model.dart';
import 'package:internapp/viewmodel/todaysorderviewmodel.dart';
import 'package:jiffy/jiffy.dart';

class TodaysOrderPage extends StatefulWidget {
  const TodaysOrderPage({ Key? key }) : super(key: key);

  @override
  State<TodaysOrderPage> createState() => _TodaysOrderPageState();
}

class _TodaysOrderPageState extends State<TodaysOrderPage> {
  final TodaysOrderViewModel _viewModel = TodaysOrderViewModel.instance;
  final TextEditingController controller = TextEditingController();
  String searchString = "";
  String dropdownvalue = 'All';

  var items = [
    'Paid',
    'Pending',
    'All'
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    DateTime current = DateTime.now();

    // ignore: unused_local_variable
    String date = Jiffy(current).format('MMMM dd, yyyy');

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
                height: 160,
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

                child: Column(
                  children: [
                    Container(
                      height: 50,
                      padding: const EdgeInsets.only(left: 20, top: 5),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.calendar_today_sharp),
                          ),
                          Text(date, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      )
                    ),
                    
                    Container(
                      width: size.width,
                      height: 55,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      margin: const EdgeInsets.only(bottom: 15),
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
                                  child:
                                    const Icon(Icons.search_rounded, color: Colors.white),
                                )
                              ),
                            ),
                          ),

                          Container(
                            height: 48,
                            width: 110,
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              color: Colors.grey.shade300,
                            ),
                            child: Center(
                              child: DropdownButton(
                                isExpanded: false,
                                value: dropdownvalue,
                                elevation: 0,
                                style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                                icon: Icon(Icons.expand_more_sharp, color: Colors.grey.shade600,),
                                items: items.map((String items) {
                                  return DropdownMenuItem(
                                    child: Text(items),
                                    value: items,
                                  );
                                }).toList(), 
                                onChanged: (String? newValue){
                                  setState(() {
                                    dropdownvalue= newValue!;
                                  });
                                },
                              ),
                            ),
                          ) 
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
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
                              child: Text('Status', 
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                              ),
                            )
                          ),
          
                          SizedBox(
                            width: 125,
                            child: Center(
                              child: Text('No. Products', 
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                              ),
                            )
                          )
                        ],
                      ),
                    ),

                  ],
                ),
              ),

              Container(
                height: 555,
                margin: const EdgeInsets.only(top: 15),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: StreamBuilder<List<OrderModel>>(
                  stream: _viewModel.stream,
                  builder: (_, snapshot) {
                    if (snapshot.hasData && !snapshot.hasError){
                      if (snapshot.data!.isNotEmpty) {

                        if(dropdownvalue == "Pending"){
                          final List<OrderModel> pendinglist = snapshot.data!.where((element) => 
                            element.customer!.name.toLowerCase().contains(searchString) &&
                            element.status == false
                          ).toList();

                            return ListView.separated(
                              shrinkWrap: true,
                              itemCount: pendinglist.length ,
                              itemBuilder: (BuildContext ctx, int index ){
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context, MaterialPageRoute(
                                        builder: (context) => ConfirmOrderPage(
                                          isfromPendingOrder: true,
                                          cusid: pendinglist[index].customer!.id,
                                          cusname: pendinglist[index].customer?.name ?? "N/A",
                                          orderid: pendinglist[index].id,
                                          status: pendinglist[index].status ? "Paid" : "Pending",
                                        )
                                      )
                                    );
                                  },
                            
                                  child: Container(
                                    color: Colors.grey.shade100,
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 125,
                                          child: Center(
                                            child: Text(pendinglist[index].customer?.name ?? "N/A",
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
                                            child: Text(pendinglist[index].status ? "Paid" : "Pending",
                                              style: const TextStyle(
                                                color: Color.fromARGB(255, 40, 84, 232),
                                                fontSize: 18,
                                              )
                                            ),
                                          ),
                                        ),
                                          
                                        SizedBox(
                                          width: 125,
                                          child: Center(
                                            child: Text(pendinglist[index].qty.toString(),
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

                          else if(dropdownvalue == "Paid"){
                            final List<OrderModel> paidlist = snapshot.data!.where((element) => 
                              element.customer!.name.toLowerCase().contains(searchString)
                              && element.status == true).toList();

                            return ListView.separated(
                              shrinkWrap: true,
                              itemCount: paidlist.length ,
                              itemBuilder: (BuildContext ctx, int index ){
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context, MaterialPageRoute(
                                        builder: (context) => ConfirmOrderPage(
                                          isfromPendingOrder: true,
                                          cusid: paidlist[index].customer!.id,
                                          cusname: paidlist[index].customer!.name,
                                          orderid: paidlist[index].id,
                                          status: paidlist[index].status ? "Paid" : "Pending",
                                        )
                                      )
                                    );
                                  },
                            
                                  child: Container(
                                    color: Colors.grey.shade100,
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 125,
                                          child: Center(
                                            child: Text(paidlist[index].customer!.name,
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
                                            child: Text(paidlist[index].status ? "Paid" : "Pending",
                                              style: const TextStyle(
                                                color: Color.fromARGB(255, 40, 84, 232),
                                                fontSize: 18,
                                              )
                                            ),
                                          ),
                                        ),
                                          
                                        SizedBox(
                                          width: 125,
                                          child: Center(
                                            child: Text(paidlist[index].qty.toString(),
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
                        // }

                        else{
                          final List<OrderModel> searchCustomer = snapshot.data!.where((element) => element.customer!.name.toLowerCase().contains(searchString)).toList();
                      
                          return ListView.separated(
                            shrinkWrap: true,
                            itemCount: searchCustomer.length ,
                            itemBuilder: (BuildContext ctx, int index ){
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context, MaterialPageRoute(
                                      builder: (context) => ConfirmOrderPage(
                                        isfromPendingOrder: true,
                                        cusid: searchCustomer[index].customer!.id,
                                        cusname: searchCustomer[index].customer!.name,
                                        orderid: searchCustomer[index].id,
                                        status: searchCustomer[index].status ? "Paid" : "Pending",
                                      )
                                    )
                                  );
                                },
                          
                                child: Container(
                                  color: Colors.grey.shade100,
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 125,
                                        child: Center(
                                          child: Text(searchCustomer[index].customer!.name,
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
                                          child: Text(searchCustomer[index].status ? "Paid" : "Pending",
                                            style: const TextStyle(
                                              color: Color.fromARGB(255, 40, 84, 232),
                                              fontSize: 18,
                                            )
                                          ),
                                        ),
                                      ),
                                        
                                      SizedBox(
                                        width: 125,
                                        child: Center(
                                          child: Text(searchCustomer[index].qty.toString(),
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
                        
                      }
                      return const Center(
                        child: Text('No Order Today',
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