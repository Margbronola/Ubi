import 'package:flutter/material.dart';
import 'package:internapp/list.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        minChildSize: .08,
        initialChildSize: .8,
        maxChildSize: .8,
        builder: (context, scrollController){
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50)
              ),
            ),
            child: ListView(
              controller: scrollController,
              children: [
                Padding(
                padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 30, bottom: 10),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade100,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(26),
                          child: ImageIcon(const AssetImage("assets/icons/Menu.png"),
                          color: Colors.orange.shade700),
                        )
                      ),

                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: const Text('MY MENU', 
                        style: TextStyle(
                          fontSize: 30,
                          letterSpacing: 3,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(color:Colors.grey.shade300, thickness: 3),
                ),

                const list(),
              ],
            ),
          );
        }
    );
  }
}