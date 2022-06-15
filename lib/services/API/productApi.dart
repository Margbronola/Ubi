// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:internapp/global/access.dart';
import 'package:internapp/global/network.dart';
import 'package:internapp/model/product_model.dart';
import 'package:internapp/viewmodel/productviewmodel.dart';

class ProductAPI{
  final ProductViewModel _viewModel = ProductViewModel.instance;
  Future<ProductModel?> getProduct() async {
    try {
      return await http.get(Uri.parse("${Network.url}/products"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken"
        },
      ).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          List<ProductModel> p = [];
          for(var prod in data){
            p.add(ProductModel.fromJson(prod));
          }
          // ignore: avoid_print
          print("Products : ${p.length}");
          _viewModel.populate(p);
          return productDetails;
        }
        return null;
        
      });
    }
    catch (e){
      return null;
    }
  }
}