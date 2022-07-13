import 'package:flutter/material.dart';
import 'package:internapp/customerdetails.dart';
import 'package:internapp/model/customer_model.dart';
import 'package:internapp/viewmodel/customerviewmodel.dart';
import 'package:page_transition/page_transition.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({Key? key}) : super(key: key);

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final CustomerViewModel _viewModel = CustomerViewModel.instance;
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
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 0),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: size.width,
                  height: 75,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:BorderSide(color: Colors.grey.shade300),
                            ),
                            hintText: 'Search Customer',
                            hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            suffixIconConstraints: const BoxConstraints(
                              maxHeight: double.maxFinite,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
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
                    ],
                  ),
                ),
              
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: StreamBuilder<List<CustomerModel>>(
                    stream: _viewModel.stream,
                    builder: (_, snapshot) {
                      if (snapshot.hasData && !snapshot.hasError) {
                        if (snapshot.data!.isNotEmpty) {
                          final List<CustomerModel> searchCustomer = snapshot.data!.where((element) => 
                          element.name.toLowerCase().contains(searchString)).toList();
                          
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            itemCount: searchCustomer.length,
                            itemBuilder: (BuildContext ctx, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context, PageTransition(
                                      type: PageTransitionType.rightToLeftWithFade,
                                      child: CustomerDetailsPage(
                                        customer: searchCustomer[index]
                                      ),
                                    )
                                  );
                                },
                              
                                child: Container(
                                  padding: const EdgeInsets.only(left: 20, right: 10),
                                  color: Colors.grey.shade200,
                                  height: 45,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(searchCustomer[index].name,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          )
                                        ),

                                        const Icon(Icons.chevron_right_rounded,
                                          color: Colors.black, 
                                          // size: 30
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },  
                          
                            separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.transparent),
                          );
                        }
                      
                        return const Center(
                          child: Text('No Customer entry',
                            style: TextStyle(fontSize: 25, letterSpacing: 2)
                          )
                        );
                      }
                      
                      return const Center(
                        child: CircularProgressIndicator.adaptive()
                      );
                    }
                  ),
                )
              ],
            )
          ),
        ),
      ), 
    );
  }
}
