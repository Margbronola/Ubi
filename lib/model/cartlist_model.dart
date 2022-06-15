import 'package:internapp/model/customer_model.dart';
import 'package:internapp/model/product_model.dart';

class CartListModel{
  final int id;
  bool status;
  final int qty;
  final double price;
  final double total;
  final ProductModel product;
  final CustomerModel customer;
  final String comment;

  CartListModel({
    required this.id,
    required this.status,
    required this.qty,
    required this.price,
    required this.total,
    required this.product,
    required this.customer,
    required this.comment,
  });

  factory CartListModel.fromJson(Map<String, dynamic> json) => CartListModel(
      id: json['id'],
      status: json['status'],
      qty: json['quantity'],
      price: double.parse(json['price'].toString()),
      total: double.parse(json['total'].toString()),
      product: ProductModel.fromJson(json['products']),
      customer: CustomerModel.fromJson(json['customer']),
      comment: json['comment'],
  );
}