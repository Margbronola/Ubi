import 'package:floating_bottom_nav_bar_list/floating_bottom_nav_bar_list.dart';
import 'package:flutter/material.dart';
import 'package:internapp/customer.dart';
import 'package:internapp/orderpage.dart';
import 'package:internapp/orderwocustomer.dart';
import 'package:internapp/outofstock.dart';
import 'package:internapp/pendingorder.dart';
import 'package:internapp/productpage.dart';
import 'package:internapp/producttoprepare.dart';
import 'package:internapp/scanner.dart';
import 'package:internapp/takeorderpage.dart';
import 'package:internapp/todaysorderpage.dart';

int currentIndex = 0;
bool isGridView = true;

final List<FloatingBottomNavListItem> navItems = [
  FloatingBottomNavListItem(
      id: 1,
      icon: const ImageIcon(AssetImage("assets/icons/takeorder.png")),
      title: const Text("Take Order")),

  FloatingBottomNavListItem(
      id: 2,
      icon: const ImageIcon(AssetImage("assets/icons/takeorderwithoutcustomer.png")),
      title: const Text("Order w/o Customer")),

  FloatingBottomNavListItem(
      id: 3,
      icon: const ImageIcon(AssetImage("assets/icons/pendingorder.png")),
      title: const Text("Pending Order")),

  FloatingBottomNavListItem(
      id: 4,
      icon: const ImageIcon(AssetImage("assets/icons/today'sorder.png")),
      title: const Text("Today's Orders")),

  FloatingBottomNavListItem(
      id: 5,
      icon: const ImageIcon(AssetImage("assets/icons/producttoprepare.png")),
      title: const Text("Products to Prepare")),

  FloatingBottomNavListItem(
      id: 6,
      icon: const ImageIcon(AssetImage("assets/icons/outofstuckproduct.png")),
      title: const Text("Out of Stock Product")),

  FloatingBottomNavListItem(
      id: 7, 
      icon: const ImageIcon(AssetImage("assets/icons/customer.png")), 
      title: const Text("Customer")),

  FloatingBottomNavListItem(
      id: 8,
      icon: const ImageIcon(AssetImage("assets/icons/Product.png")),
      title: const Text("Products")),

  FloatingBottomNavListItem(
      id: 9,
      icon: const ImageIcon(AssetImage("assets/icons/order.png")),
      title: const Text("Order")),

  FloatingBottomNavListItem(
      id: 10,
      icon: const ImageIcon(AssetImage("assets/icons/qrscanner.png")),
      title: const Text("QR Scanner")),
];


final  List<Map> contents = [
    {
      "id": 1,
      "name": "TakeOrder",
      "icon": const ImageIcon(AssetImage("assets/icons/takeorder.png")),
      "child": const TakeOrderPage(),
    },

    {
      "id": 2,
      "name": "Order w/o Customer",
      "icon": const ImageIcon(AssetImage("assets/icons/takeorderwithoutcustomer.png"),),
      "child": const OrderWithoutCustomer(),
    },

    {
      "id": 3,
      "name": "Pending Order",
      "icon": const ImageIcon(AssetImage("assets/icons/pendingorder.png")),
      "child": PendingOrderPage(),
    },

    {
      
      "id": 4,
      "name": "Today's Order",
      "icon": const ImageIcon(AssetImage("assets/icons/today'sorder.png")),
      "child": const TodaysOrderPage(),
    },

    {
      "id": 5,
      "name": "Product's to prepare",
      "icon": const ImageIcon(AssetImage("assets/icons/producttoprepare.png")),
      "child": const ProductsToPreparePage(),
    },

    {
      "id": 6,
      "name": "Out of Stock Product",
      "icon": const ImageIcon(AssetImage("assets/icons/outofstuckproduct.png")),
      "child": const OutofStockPage(),
    },

    {
      "id": 7,
      "name": "Customer",
      "icon": const ImageIcon(AssetImage("assets/icons/customer.png")),
      "child": const CustomerPage(),
    },
    
    {
      "id": 8,
      "name": "Product",
      "icon": const ImageIcon(AssetImage("assets/icons/Product.png")),
      "child": ProductPage(),
    },
    
    {
      "id": 9,
      "name": "Order",
      "icon": const ImageIcon(AssetImage("assets/icons/order.png")),
      "child": const OrderPage(),
    },

    {
      "id": 10,
      "name": "Scanner",
      "icon": const ImageIcon(AssetImage("assets/icons/qrscanner.png")),
      "child": ScannerPage(),
    },
  ];  