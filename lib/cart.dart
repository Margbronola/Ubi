import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:internapp/profile_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({ Key? key }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // final CartListViewModel _viewModel = CartListViewModel.instance;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset("assets/images/Only_Logo.png"),
        ),
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
        automaticallyImplyLeading: false,
        elevation: 5,
        backgroundColor: const Color.fromARGB(255, 40, 84, 232),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.amberAccent.shade200, 
      ),
    );
  }
}