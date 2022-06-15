import 'package:internapp/model/product_model.dart';

class OrderProductModel{
  final int id;
  final double price;
  final String? comment;
  final int qty;
  final bool prepared;
  final ProductModel product;

  OrderProductModel({
    required this.id,
    required this.price,
    required this.comment,
    required this.qty,
    required this.prepared,
    required this.product
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) => OrderProductModel(
      id: json['id'],
      price: double.parse(json['price'].toString()),
      comment: json['comment'],
      qty: json['quantity'],
      prepared: json['prepared'] != null ? int.parse(json['prepared'].toString()) == 1 : false,
      product: ProductModel.fromJson(json['products'])
  );
}