// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'package:internapp/global/access.dart';
import 'package:internapp/model/producttoprepare_model.dart';
import 'package:internapp/viewmodel/producttoprepareviewmodel.dart';
import '../../global/network.dart';
import 'package:http/http.dart' as http;

class ProductToPrepareAPI{
  final ProductToPrepareViewModel _viewModel = ProductToPrepareViewModel.instance;

  Future<ProductToPrepareModel?> getToPrepare() async{
    try{
      return await http.get(Uri.parse("${Network.url}/toprepared"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $accessToken"
      },
      ).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          List<ProductToPrepareModel> tp = [];
          for(var prepare in data){
            tp.add(ProductToPrepareModel.fromJson(prepare));
          }
          print("to Prepare Product: ${tp.length}");
          _viewModel.populate(tp);
          return topreparelist;
        }
        return null;
      });
    }
    catch (e){
      return null;
    }
  }

  Future<bool> markPrepared({int? preparedID}) async{
    try{
      return await http.post(Uri.parse("${Network.url}/markprepared/$preparedID"),
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
}