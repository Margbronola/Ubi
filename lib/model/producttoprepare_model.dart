import 'package:internapp/model/orders_model.dart';
import 'package:internapp/model/product_model.dart';

class ProductToPrepareModel{
  final int id;
  final int qty;
  final double price;
  final bool prepared;
  final String? comment;
  final ProductModel products;
  final OrdersModel order;

  ProductToPrepareModel({
    required this.id,
    required this.qty,
    required this.price,
    required this.prepared,
    required this.comment,
    required this.products,
    required this.order
  });

  factory ProductToPrepareModel.fromJson(Map<String, dynamic> json) => ProductToPrepareModel(
    id: json['id'],
    qty: json['quantity'],
    price: double.parse(json['price'].toString()),
    prepared: json['prepared'] != null ? int.parse(json['prepared'].toString()) == 1 : false,
    comment: json['comment'],
    products: ProductModel.fromJson(json['products']),
    order: OrdersModel.fromJson(json['orders'])
  );
}