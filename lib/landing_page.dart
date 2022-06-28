import 'dart:ui';
import 'package:floating_bottom_nav_bar_list/floating_bottom_nav_bar_list.dart';
import 'package:flutter/material.dart';
import 'package:internapp/global/access.dart';
import 'package:internapp/global/app.dart';
import 'package:internapp/menu.dart';
import 'package:internapp/profile_page.dart';
import 'package:internapp/services/API/auth.dart';
import 'package:internapp/services/API/customerApi.dart';
import 'package:internapp/services/API/ordersApi.dart';
import 'package:internapp/services/API/productApi.dart';
import 'package:internapp/services/API/todaysorderApi.dart';
import 'package:internapp/services/API/toprepareApi.dart';
import 'package:internapp/viewmodel/navigationbuttonviewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final Auth _auth = Auth();
  final ProductAPI _productAPI = ProductAPI();
  final CustomerAPI _customerAPI = CustomerAPI();
  final ToPrepareAPI _toPrepareAPI = ToPrepareAPI();
  final TodaysOrderApi _todayOrderAPI = TodaysOrderApi();
  final OrdersAPI _ordersAPI = OrdersAPI();
  final NavigationButtonViewModel _viewModel = NavigationButtonViewModel.instance;

  checkMenu() async {
    if (!mounted) return;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool hasMenu = _prefs.containsKey("menu_ids");
    // ignore: avoid_print
    print(hasMenu);
  }

  Future<void> fetch() async {
    await _auth.getUserDetails().then((value) async {
      if (value != null) {
        setState(() {
          loggedUser = value;
        });
      }
    });
  }

  @override
  void initState() {
    _ordersAPI.getOrders();
    _productAPI.getProduct();
    _customerAPI.getCustomer();
    _toPrepareAPI.getToPrepare();
    _todayOrderAPI.getOrder();
    checkMenu();

    init();
    super.initState();
  }

  init() async {
    await fetch();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
          child: Image.asset("assets/images/Only_Logo.png"),
        ),

        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 14, top:5, bottom:5),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),

              child: IconButton(
                onPressed: loggedUser == null ? null : (){
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
          ),
        ],
        automaticallyImplyLeading: false,
        elevation: 5,
        backgroundColor: const Color.fromARGB(255, 40, 84, 232),
      ),
      
      body: loggedUser == null ? const Center(
        child: CircularProgressIndicator.adaptive()
      ) : StreamBuilder<List<int>> (
        stream: _viewModel.stream,
        builder: (context, snapshot) {
          if(snapshot.hasData && !snapshot.hasError && snapshot.data!.isNotEmpty){
            return Stack(
              alignment: Alignment.center,
              children: [
                // snapshot.hasData && !snapshot.hasError && snapshot.data!.isNotEmpty ? 
                contents.where((element) => element['id'] == snapshot.data![currentIndex])
                .first['child'] ,
                // : const Menu(isNewUser: true),
                  
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * .12),
                      child: Center(
                        child: snapshot.hasData && !snapshot.hasError ? FloatingBottomNavList(
                          disabledColor: const Color.fromARGB(255, 232, 149, 40),
                          backgroundColor: Colors.grey.shade200,
                          selectedIndex: currentIndex,
                          activeColor:const Color.fromARGB(255, 40, 84, 232),
                          backgroundRadius: 30,
                          items: [
                            ...snapshot.data!.map((id) {
                              return navItems.where((element) => element.id == id).first;
                            }),
                          ],
                          onTap: (index) {
                            setState(() => currentIndex = index);
                          },
                        ): const Center(
                          child: CircularProgressIndicator.adaptive()
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const Menu(isNewUser: true);
        }
      )
    );
  }
}