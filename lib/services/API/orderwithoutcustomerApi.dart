// ignore_for_file: file_names

import 'package:internapp/global/access.dart';
import 'package:internapp/global/network.dart';
import 'package:http/http.dart' as http;

class WithoutCustomerApi{
  Future<bool> confirmOrderwithoutCustomer({
    int? quantity,
    int? productid,
    String? comment,
  }) async{
    try{
      return await http.post(Uri.parse("${Network.url}/confirmnocustomer"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken"
        },
      // ignore: void_checks
      ).then((response) {
        return response.statusCode == 200;
      },);
    }
    catch (e) {
      return false;
    }
  }

  // Future<void> displayOrderwithoutCustomer() async{
  //   try{
  //     return await http.get(Uri.parse("${Network.url}/cartnocustomer"),
  //       headers: {
  //         "Accept": "application/json",
  //         HttpHeaders.authorizationHeader : "Bearer $accessToken"
  //       },
  //     ).then((response) {
  //       var data = json.decode(response.body);
  //       if(response.statusCode == 200){
  //         final CartModel model = CartModel.fromJson(data);
  //         // ignore: avoid_print
  //         print("order : ${model.cart.length}");
  //         _viewModel.populate(model);
  //       return;
  //       }
  //       return null;
  //     });
  //   }
  //   catch(e){
  //     return;
  //   }
  // }


}