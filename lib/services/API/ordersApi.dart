// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:internapp/global/access.dart';
import 'package:internapp/global/network.dart';
import 'package:internapp/model/orders_model.dart';
import 'package:internapp/viewmodel/ordersviewmodel.dart';

class OrdersAPI{
  final OrdersViewModel _viewModel = OrdersViewModel.instance;
  
  Future<OrdersModel?> getOrders() async{
    try{
      return await http.get(Uri.parse("${Network.url}/displayAll/Paid"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken"
        },
      ).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          List<OrdersModel> o = [];
          for(var orders in data){
            o.add(OrdersModel.fromJson(orders));
          }
          // ignore: avoid_print
          print("All Orders : ${o.length}");
          _viewModel.populate(o);
          return order;
        }
        return null;
      });
    }
    catch(e){
      return null;
    }
  }
}