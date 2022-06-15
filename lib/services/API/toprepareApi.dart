// ignore_for_file: file_names

import 'dart:convert';
import 'package:internapp/global/access.dart';
import 'package:internapp/model/toprepare_model.dart';
import 'package:internapp/viewmodel/toprepareviewmodel.dart';
import '../../global/network.dart';
import 'package:http/http.dart' as http;

class ToPrepareAPI{
  final ToPrepareViewModel _viewModel = ToPrepareViewModel.instance;

  Future<ToPrepareModel?> getToPrepare() async{
    try{
      return await http.get(Uri.parse("${Network.url}/toprepared"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $accessToken"
      },
      ).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          List<ToPrepareModel> tp = [];
          for(var prepare in data){
            tp.add(ToPrepareModel.fromJson(prepare));
          }
          // ignore: avoid_print
          print("to Prepare : ${tp.length}");
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
        // var data = json.decode(response.body);
          return response.statusCode == 200;
      });
    }
    catch(e){
      return false;
    }
  }
}