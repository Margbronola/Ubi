// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'package:internapp/global/access.dart';
import 'package:internapp/global/network.dart';
import 'package:http/http.dart' as http;
import 'package:internapp/model/order_model.dart';

class OrderDetailsApi{
  Future<OrderModel?> getOrderdetails({required int orderId}) async {
    try{
      return await http.get(Uri.parse("${Network.url}/displayOrder/$orderId"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $accessToken"
      },
      ).then((response){
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          final OrderModel model = OrderModel.fromJson(data);
          print("Orders: ${model.orderproduct.length}");
          return model;
        }
        return null;
      });
    }
    catch (e){
      return null;
    }
  } 
  
}