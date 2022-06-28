// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'package:internapp/global/access.dart';
import 'package:internapp/global/network.dart';
import 'package:internapp/model/todaysorder_model.dart';
import 'package:internapp/viewmodel/todaysorderviewmodel.dart';
import 'package:http/http.dart' as http;

class TodaysOrderApi{
  final TodaysOrderViewModel _viewModel = TodaysOrderViewModel.instance;

  Future<TodaysOrderModel?> getAllOrder() async{
    try{
      return await http.get(Uri.parse("${Network.url}/orderproduct"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $accessToken"
      },
      ).then((response){
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          List<TodaysOrderModel> to = [];
          for(var todayOrder in data){
            to.add(TodaysOrderModel.fromJson(todayOrder));
          }
          print(" All Orders (Paid & Pending): ${to.length}");
          _viewModel.populate(to);
        return todaysOrderlist;
        }
        return null;
      });
    }
    catch (e){
      return null;
    }
  } 
}