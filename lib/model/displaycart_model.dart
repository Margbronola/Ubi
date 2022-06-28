import 'package:internapp/model/cartdetails_model.dart';
import 'package:internapp/model/customer_model.dart';

class DisplayCartModel{
  final int id;
  double total;
  CustomerModel? customer;
  List<CartDetailsModel> carts;
  
  DisplayCartModel(
    {
      required this.id,
      required this.total,
      required this.customer,
      required this.carts
    }
  );

  static List<CartDetailsModel> cartDetails(List?data){
      List<CartDetailsModel> ff = [];
      if(data != null){
        for(var datum in data){
          ff.add(CartDetailsModel.fromJson(datum));
        }
      }
      return ff;
    }

  factory DisplayCartModel.fromJson(Map<String, dynamic> json) => DisplayCartModel(
      id: int.parse(json['id'].toString()),
      total: double.parse(json['total'].toString()),
      customer: json['customer'] == null ? null : CustomerModel.fromJson(json['customer']),
      carts: cartDetails(json['carts'])
  );
}