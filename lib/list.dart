import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internapp/global/custom_switcher.dart';
import 'package:internapp/profile_page.dart';
import 'package:internapp/viewmodel/navigationbuttonviewmodel.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// ignore: camel_case_types
class list extends StatefulWidget {
  const list({ Key? key }) : super(key: key);

  @override
  State<list> createState() => _listState();
}

// ignore: camel_case_types
class _listState extends State<list> {
  final NavigationButtonViewModel _viewModel = NavigationButtonViewModel.instance;
  StreamController<double> controller = StreamController<double>();
  
  Widget switcherData({required List<SwitcherData> switchData,}) => Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...switchData.map(
              (e) => Padding(
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: e.icon,
                    ),

                    const SizedBox(
                      width: 20,
                    ),

                    Expanded(
                      child: Text(
                        e.title,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),

                    CustomSwitcher(
                      isEnabled: e.isEnabled,
                      callback: (bool x) {
                        _viewModel.control(e.id);
                        // ignore: avoid_print
                        print('added ${_viewModel.current}');
                        setState(() {});
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
      
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: 510,
      padding: const EdgeInsets.only(right: 20),
      child: StreamBuilder<List<int>>(
        stream: _viewModel.stream,
        builder: (context,snapshot) {
          // ignore: curly_braces_in_flow_control_structures
          if(!snapshot.hasData || snapshot.hasError) return  Center(child: LoadingAnimationWidget.prograssiveDots(color: const Color.fromARGB(255, 40, 84, 232), size: 50));
        
          return Column(
            // padding: const EdgeInsets.symmetric(vertical: 0),
            children: [
              switcherData(switchData: [
                SwitcherData(
                  id: 1,
                  icon: const ImageIcon(AssetImage("assets/icons/takeorder.png"),
                    color: Color.fromARGB(255, 232, 149, 40),
                  ),
                  title: "Take Order",
                  onPressed: () {},
                  isEnabled: snapshot.data!.contains(1),
                ),

                SwitcherData(
                  id: 2,
                  icon: const ImageIcon(AssetImage("assets/icons/takeorderwithoutcustomer.png"),
                    color: Color.fromARGB(255, 232, 149, 40),
                  ),
                  title: "Order w/o Customer",
                  onPressed: () {},
                  isEnabled: snapshot.data!.contains(2)
                ),

                SwitcherData(
                  id: 3,
                  icon: const ImageIcon(AssetImage("assets/icons/pendingorder.png"),
                    color: Color.fromARGB(255, 232, 149, 40),
                  ),
                  title: "Pending Order",
                  onPressed: () {},
                  isEnabled: snapshot.data!.contains(3)
                ),

                SwitcherData(
                  id: 4,
                  icon: const ImageIcon(AssetImage("assets/icons/today'sorder.png"),
                    color: Color.fromARGB(255, 232, 149, 40),
                  ),
                  title: "Today's Order",
                  onPressed: () {},
                  isEnabled: snapshot.data!.contains(4)
                ),

                SwitcherData(
                  id: 5,
                  icon: const ImageIcon(AssetImage("assets/icons/producttoprepare.png"),
                    color: Color.fromARGB(255, 232, 149, 40),
                  ),
                  title: "Products to Prepare",
                  onPressed: () {},
                  isEnabled: snapshot.data!.contains(5)
                ),

                SwitcherData(
                  id: 6,
                  icon: const ImageIcon(AssetImage("assets/icons/outofstuckproduct.png"),
                    color: Color.fromARGB(255, 232, 149, 40),
                  ),
                  title: "Out of Stock Product",
                  onPressed: () {},
                  isEnabled: snapshot.data!.contains(6)
                ),

                SwitcherData(
                  id: 7,
                  icon: const ImageIcon(AssetImage("assets/icons/customer.png"),
                    color: Color.fromARGB(255, 232, 149, 40),
                  ),
                  title: "Customer",
                  onPressed: () {},
                  isEnabled: snapshot.data!.contains(7)
                ),

                SwitcherData(
                  id: 8,
                  icon: const ImageIcon(AssetImage("assets/icons/Product.png"),
                    color: Color.fromARGB(255, 232, 149, 40),
                  ),
                  title: "Products",
                  onPressed: () {},
                  isEnabled: snapshot.data!.contains(8)
                ),

                SwitcherData(
                  id: 9,
                  icon: const ImageIcon(AssetImage("assets/icons/order.png"),
                    color: Color.fromARGB(255, 232, 149, 40),
                  ),
                  title: "Order",
                  onPressed: () {},
                  isEnabled: snapshot.data!.contains(9)
                ),

                // SwitcherData(
                //   id: 10,
                //   icon: const ImageIcon(AssetImage("assets/icons/qrscanner.png"),
                //     color: Color.fromARGB(255, 232, 149, 40),
                //   ),
                //   title: "Qr Scanner",
                //   onPressed: () {},
                //   isEnabled: snapshot.data!.contains(10)
                // ),
              ]),
            ],
          );
        }
      ),
    );
  }
}