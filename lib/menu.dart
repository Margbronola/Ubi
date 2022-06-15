import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internapp/global/custom_switcher.dart';
import 'package:internapp/list.dart';
import 'package:internapp/profile_page.dart';
import 'package:internapp/viewmodel/navigationbuttonviewmodel.dart';

class Menu extends StatefulWidget {
  const Menu({ Key? key, this.isNewUser = false}) : super(key: key);
  final bool isNewUser;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
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

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.grey.shade200,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Please select your chosen preset to display in your navigation bar.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 19,
                ),
              ),
            ),

            const list(),

            Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
              child: SizedBox(
                width: size.width,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    primary: const Color.fromARGB(255, 27, 140, 174)
                  ),
                  onPressed: () {  },
                  child: const Text('CONTINUE',
                    style: TextStyle(fontSize: 22, letterSpacing: 4),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}