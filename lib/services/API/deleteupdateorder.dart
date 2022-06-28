// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:internapp/global/access.dart';
import 'package:internapp/global/network.dart';
import 'package:internapp/model/cartdetails_model.dart';

class DeleteUpdateOrderCart{

  Future<bool> delete({int? cartID}) async{
    try{
      return await http.get(
        Uri.parse("${Network.url}/deletecart/$cartID"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken"
        },
      ).then((response) {
        return response.statusCode == 200;
        });
    }
    catch(e){
      return false;
    }
  }

  Future<CartDetailsModel?> update({
    int? cartID,
    int? qty,
    String? comment,
  }) async{
    try{
      return await http.post(
        Uri.parse("${Network.url}/updatecart/${cartID.toString()}"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: {
          "quantity" : qty.toString(),
          "comment" : comment,
        }
      ).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          cartlist = CartDetailsModel.fromJson(data);
          return cartlist;
        }
        return null;
      });
    }
    catch(e){
      return null;
    }
  }
}