import 'package:internapp/model/product_model.dart';

class CartDetailsModel{
  final int id;
  bool status;
  int qty;
  double price;
  double total;
  String? comment;
  ProductModel product;
  
  CartDetailsModel(
    {
      required this.id,
      required this.status,
      required this.qty,
      required this.price,
      required this.total,
      required this.comment,
      required this.product
    }
  );

  factory CartDetailsModel.fromJson(Map<String, dynamic> json) => CartDetailsModel(
      id: int.parse(json['id'].toString()),
      status: json['status'] != null ? int.parse(json['status'].toString()) == 1 : false,
      qty: int.parse(json['quantity'].toString()),
      price: double.parse(json['price'].toString()),
      total: double.parse(json['total'].toString()),
      comment: json['comment'],
      product: ProductModel.fromJson(json['products'])
  );
}