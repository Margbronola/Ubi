// ignore_for_file: file_names, avoid_print

import 'dart:convert';

import 'package:internapp/global/access.dart';
import 'package:internapp/global/network.dart';
import 'package:http/http.dart' as http;
import 'package:internapp/model/pendingorderdetails_model.dart';
import 'package:internapp/viewmodel/pendingorderdetailsviewmodel.dart';

class OrdertoPrepareByCustomerApi{
  final PendingOrderDetailsViewModel _viewModel = PendingOrderDetailsViewModel.instance;

  Future<PendingOrderDetailsModel?> getPendingOrderDetails({int? customerID}) async{
    try{
      return await http.get(Uri.parse("${Network.url}/ordertoprepared/$customerID"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken"
        },
      ).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          List<PendingOrderDetailsModel> p = [];
          for(var prepare in data){
            p.add(PendingOrderDetailsModel.fromJson(prepare));
          }
          print("to Prepare Orders : ${p.length}");
          _viewModel.populate(p);
        return pendingorder;
        }
        return null;
        
      });
    }
    
    catch(e){
      print(e);
      return null;
    }
  }
}