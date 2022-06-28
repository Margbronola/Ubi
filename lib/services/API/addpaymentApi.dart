// ignore_for_file: file_names, avoid_print

import 'package:http/http.dart' as http;
import 'package:internapp/global/access.dart';
import 'package:internapp/global/network.dart';

class AddPayment{
  Future <bool> payment({
    int? cartcustomerId,
    required double amount,
    }) async{
    try{
      return await http.post(
        Uri.parse("${Network.url}/paymentorder/$cartcustomerId"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: {
          "paid": amount.toString(),
        },
      ).then((response) {
        return response.statusCode == 200;
      },);
    }
    catch (e) {
      print("mali : $e");
      return false;
    }
  }

  Future <bool> paymentbyOrder({
    int? orderID,
    required double amount,
    }) async{
    try{
      return await http.post(
        Uri.parse("${Network.url}/payOrder/$orderID"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: {
          "paid": amount.toString(),
        },
      ).then((response) {
        return response.statusCode == 200;
      },);
    }
    catch (e) {
      return false;
    }
  }

}