// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:internapp/global/access.dart';
import 'package:internapp/global/network.dart';
import 'package:internapp/model/user_model.dart';
import 'package:internapp/services/API/datacacher.dart';

class Auth {
  final DataCacher _cacher = DataCacher.instance;
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      return await http.post(
        Uri.parse("${Network.url}/login"),
        headers: {
          "Accept": "application/json",
        },
        body: {
          "email": email,
          "password": password,
        },
      ).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          accessToken = data['accesstoken'];
          _cacher.uToken = accessToken;
          return true;
        }
        // ignore:
        print("ERROR: $data");
        return false;
      },);
    } catch (e) {
      print("ERROR sa login: $e");
      return false;
    }
  }

  Future<bool> logout() async {
    try{
      return await http.post(
        Uri.parse("${Network.url}/logout"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken"
        },
      ).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          loggedUser = null;
          return true;
        }
        print("ERROR: $data");
        return false;
      },);
    }
    catch (e) {
      print("ERROR : $e");
      return false;
    }
  }

  Future<UserModel?> getUserDetails() async {
    try {
      return await http.get(Uri.parse("${Network.url}/employeedetails"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken"
        },
      ).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          loggedUser = UserModel.fromJson(data);
        return loggedUser;
        }
        return null;
        
      });
    }
    catch (e){
      return null;
    }
  }

  Future<bool> updateUserData(
    String newName,
    String newPhoneNumber,
  ) async{
    try{
      return await http.post(Uri.parse("${Network.url}/update-profile"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: {
          "name": newName,
          "phone": newPhoneNumber,
        },
      ).then((response){
        print(response.body);
        return response.statusCode == 200;
      }); 
    }
    catch(e){
      return false;
    }
  }

  Future<bool?> changePassword(
    String oldPass,
    String newPass,
    String confirmPass,
  ) async{
    try{
      return await http.post(Uri.parse("${Network.url}/changepassword"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: {
          "old_password": oldPass,
          "password": newPass,
          "confirm_password": confirmPass,
        },
      ).then((response){
        return response.statusCode == 200;
      }); 
    }
    catch(e){
      return null;
    }
  }

}
