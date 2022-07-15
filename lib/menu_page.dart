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
        initialChildSize: .75,
        maxChildSize: .75,
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
              padding: const EdgeInsets.symmetric(vertical: 0),
              controller: scrollController,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 30, bottom: 5),
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade200,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(17),
                            child: ImageIcon(const AssetImage("assets/icons/Menu.png"),
                            color: Colors.orange.shade700),
                          )
                        ),

                        Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: const Text('MY MENU', 
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 1.5,
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