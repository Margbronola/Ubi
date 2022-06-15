import 'package:internapp/model/product_model.dart';

class CartDetailsModel{
  final int id;
  int qty;
  double price;
  double total;
  ProductModel product;
  String? comment;
  
  CartDetailsModel(
    {
      required this.id,
      required this.qty,
      required this.price,
      required this.total,
      required this.product,
      required this.comment,
    }
  );

  factory CartDetailsModel.fromJson(Map<String, dynamic> json) => CartDetailsModel(
      id: int.parse(json['id'].toString()),
      qty: int.parse(json['quantity'].toString()),
      price: double.parse(json['price'].toString()),
      total: double.parse(json['total'].toString()),
      product: ProductModel.fromJson(json['products']),
      comment: json['comment'],
  );
}