// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:internapp/global/access.dart';
import 'package:internapp/global/network.dart';
import 'package:internapp/model/addtocart_model.dart';
import 'package:internapp/model/displaycart_model.dart';

class CartApi{
  Future<AddToCartModel?> addToCart({
    int? customerID,
    int? quantity,
    int? productid,
    String? comment,
  }) async{
    try{
      Map body = {
        "quantity": quantity.toString(),
          "product_id": productid.toString(),
          "comment": comment,
      };
      
      if(customerID != null){
        body.addAll({"customer_id": customerID.toString()});
      }
      return await http.post(Uri.parse("${Network.url}/addtocart"),
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader : "Bearer $accessToken",
        },
        body: body,
      // ignore: void_checks
      ).then((response){
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          print(data);
          return AddToCartModel.fromJson(data);
        }
        return null;
      }); 
    }
    catch(e){
      return null;
    }
  }

  Future<DisplayCartModel?> getCartDetails({required int cartCustomerId}) async{
    try {
        return await http.get(Uri.parse("${Network.url}/cart/$cartCustomerId"),
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader : "Bearer $accessToken"
        },
      ).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          final DisplayCartModel model = DisplayCartModel.fromJson(data);
          print("order : ${model.carts.length}");
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