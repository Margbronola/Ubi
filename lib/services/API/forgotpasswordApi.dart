// ignore_for_file: file_names, avoid_print

import 'package:http/http.dart' as http;
import 'package:internapp/global/network.dart';

class ForgotPassApi{

  Future<bool> requestOtp({required String email,}) async{
    try{
      return await http.post(Uri.parse("${Network.url}/request_otp"),
        headers: {
          "Accept": "application/json",
        },
        body: {
          "email": email,
        },
      ).then((response) {
        print(response.body);
        return response.statusCode == 200;
      },);
    }
    catch (e){
      return false;
    }
  }

  Future<bool> verifyOtp({required String email, String? otp}) async{
    try{
      return await http.post(Uri.parse("${Network.url}/verify_otp"),
        headers: {
          "Accept": "application/json",
        },
        body: {
          "email": email,
          "otp" : otp,
        },
      ).then((response) {
        return response.statusCode == 200;
      },);
    }
    catch (e){
      return false;
    }
  }

  Future<bool> newPassword({
    required String email,
    required String password,
    required String confirmpassword,
  }) async{
    try{
      return await http.post(Uri.parse("${Network.url}/new_password"),
        headers: {
          "Accept": "application/json",
        },
        body: {
          "email": email,
          "password" : password,
          "confirmpass" : confirmpassword
        },
      ).then((response) {
        return response.statusCode == 200;
      },);
    }
    catch (e){
      return false;
    }
  }
}