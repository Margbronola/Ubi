import 'package:internapp/model/cartdetails_model.dart';

class CartModel{
  final int id;
  final String cusname; 
  final double total;
  List<CartDetailsModel> cart;


   CartModel({
    required this.id,
    required this.cusname,
    required this.total,
    required this.cart,
  });

  static List<CartDetailsModel> carttolist(
    List? data
  ){
    List<CartDetailsModel> o = [];
    if(data != null){
      for(var order in data){
            o.add(CartDetailsModel.fromJson(order));
          }
    }
          return o;
  }

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
      id: json['id'],
      cusname: json['name'],
      total: json['total'] == null ? 0.0 : double.parse(json['total'].toString()),
      cart: carttolist(json['carts']),
  );
}