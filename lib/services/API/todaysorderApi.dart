// ignore_for_file: file_names

import 'dart:convert';
import 'package:internapp/global/access.dart';
import 'package:internapp/global/network.dart';
import 'package:internapp/model/order_model.dart';
import 'package:internapp/viewmodel/todaysorderviewmodel.dart';
import 'package:http/http.dart' as http;

class TodaysOrderApi{
  final TodaysOrderViewModel _viewModel = TodaysOrderViewModel.instance;

  Future<OrderModel?> getOrder() async{
    try{
      return await http.get(Uri.parse("${Network.url}/orderproduct"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $accessToken"
      },
      ).then((response){
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          List<OrderModel> to = [];
          for(var todayOrder in data){
            to.add(OrderModel.fromJson(todayOrder));
          }
          // ignore: avoid_print
          print("Orders : ${to.length}");
          _viewModel.populate(to);
        return orderlist;
        }
        return null;
      });
    }
    catch (e){
      return null;
    }
  } 
}