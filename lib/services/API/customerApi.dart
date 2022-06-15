// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:internapp/global/access.dart';
import 'package:internapp/global/network.dart';
import 'package:internapp/model/customer_model.dart';
import 'package:internapp/viewmodel/customerviewmodel.dart';

class CustomerAPI{
  final CustomerViewModel _viewModel = CustomerViewModel.instance;
  
  Future<CustomerModel?> getCustomer() async {
    try {
      return await http.get(Uri.parse("${Network.url}/customers"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken"
        },
      ).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          List<CustomerModel> c = [];
          for(var cus in data['customers']){
            c.add(CustomerModel.fromJson(cus));
          }
          // ignore: avoid_print
          print("Customer : ${c.length}");
          _viewModel.populate(c);
          return customerDetails;
        }
        return null;
        
      });
    }
    catch (e){
      return null;
    }
  }

  Future<CustomerModel?> addNewCustomer(
    String Name,
  ) async{
    try{
      return await http.post(Uri.parse("${Network.url}/customer/store"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: {
          "name": Name,
        },
      ).then((response){
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          customerDetails = CustomerModel.fromJson(data);
          return customerDetails;
        }
        return null;
      }); 
    }
    catch(e){
      return null;
    }
  }
}