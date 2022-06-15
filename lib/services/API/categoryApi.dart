// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:internapp/global/access.dart';
import 'package:internapp/global/network.dart';
import 'package:internapp/model/category_model.dart';
import 'package:internapp/viewmodel/categoryviewmodel.dart';

class CategoryAPI{
  final CategoryViewModel _viewModel = CategoryViewModel.instance;

  Future<CategoryModel?> getCategory() async{
    try{
      return await http.get(Uri.parse("${Network.url}/categories"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken"
        },
      ).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          List<CategoryModel> c = [];
          for(var category in data){
            c.add(CategoryModel.fromJson(category));
          }
          // ignore: avoid_print
          print("Category : ${c.length}");
          _viewModel.populate(c);
        return categorylist;
        }
        return null;
        
      });
    }
    catch (e){
      return null;
    }
  } 
}