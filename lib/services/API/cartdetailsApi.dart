// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:internapp/global/access.dart';
import 'package:internapp/global/network.dart';
import 'package:internapp/model/cart_model.dart';
import 'package:internapp/model/cartdetails_model.dart';
import 'package:internapp/viewmodel/cartdetailsviewmodel.dart';

class CartDetails{
  final CartDetailsViewModel _viewModel = CartDetailsViewModel.instance;

  Future<void> addOrder({
    int? customerID,
    int? quantity,
    int? productid,
    String? comment,
  }) async{
    try{
      return await http.post(Uri.parse("${Network.url}/addtocart"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: {
          "customer_id": customerID?.toString(),
          "quantity": quantity?.toString(),
          "product_id": productid?.toString(),
          "comment": comment,
        },
      // ignore: void_checks
      ).then((response){
        var data = json.decode(response.body);
        print(data);
        if(response.statusCode == 200){
          print('added');
          print(response.body);
          return CartDetailsModel.fromJson(data);
        }
      }); 
    }
    catch(e){
      print("error sa pag add:: $e");
      return;
    }
  }

  Future<void> getCartDetails({int? cartCustomerId}) async{
    try {
        return await http.get(Uri.parse("${Network.url}/cart/$cartCustomerId"),
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader : "Bearer $accessToken"
        },
      ).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          final CartModel model = CartModel.fromJson(data);
          print("order : ${model.cart.length}");
          _viewModel.populate(model);
        return;
        }
        return null;
      });
    }
    catch (e){
      print("Error sa pagpadisplay:: $e");
      return;
    }
  }
}