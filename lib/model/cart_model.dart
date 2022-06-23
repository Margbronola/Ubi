import 'package:internapp/model/customer_model.dart';
import 'package:internapp/model/displaycart_model.dart';

class CartModel{
  final int id;
  CustomerModel? customer; 
  final double total;
  List<DisplayCartModel> cart;


   CartModel({
    required this.id,
    required this.customer,
    required this.total,
    required this.cart,
  });

  static List<DisplayCartModel> carttolist(List? data){
    List<DisplayCartModel> o = [];
    if(data != null){
      for(var datum in data){
        o.add(DisplayCartModel.fromJson(datum));
      }
    }
    return o;
  }

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
      id: json['id'],
      customer: json['customer_id'] == null ? null : CustomerModel.fromJson(json['customer_id']),
      total: json['total'] == null ? 0.0 : double.parse(json['total'].toString()),
      cart: carttolist(json['carts']),
  );
}