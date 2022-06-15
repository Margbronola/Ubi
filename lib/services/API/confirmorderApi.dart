// ignore_for_file: file_names
import 'package:http/http.dart' as http;
import 'package:internapp/global/access.dart';
import 'package:internapp/global/network.dart';

class ConfirmOrder{
  Future <bool> confirm({int? customerId}) async{
    try{
      return await http.post(
        Uri.parse("${Network.url}/confirmedorder/$customerId"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken"
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