import 'package:flutter/material.dart';
import 'package:internapp/productpage.dart';

class OrderWithoutCustomer extends StatefulWidget {
  const OrderWithoutCustomer({ Key? key }) : super(key: key);

  @override
  State<OrderWithoutCustomer> createState() => _OrderWithoutCustomerState();
}

class _OrderWithoutCustomerState extends State<OrderWithoutCustomer> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: ProductPage(isFromLocalPage: false, isFromWithoutCustomer: true),
      ),
    );
  }
}