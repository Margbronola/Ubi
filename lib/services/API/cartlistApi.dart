// ignore_for_file: file_names

import 'dart:_http';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:internapp/global/access.dart';
import 'package:internapp/global/network.dart';
import 'package:internapp/model/cartlist_model.dart';
import 'package:internapp/viewmodel/cartlistviewmodel.dart';

class CartList{
  final CartListViewModel _viewModel = CartListViewModel.instance;

  Future<void> getCartList() async{
    try {
        return await http.get(Uri.parse("${Network.url}/cart"),
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader : "Bearer $accessToken"
        },
      ).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          final CartListModel model = CartListModel.fromJson(data);
          _viewModel.populate(model);
        return;
        }
        return null;
      });
    }
    catch (e){
      // ignore: avoid_print
      print("ERRORss: $e");
      return;
    }
  }
}