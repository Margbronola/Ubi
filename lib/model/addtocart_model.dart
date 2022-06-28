import 'package:internapp/model/cartcustomer_model.dart';
import 'package:internapp/model/product_model.dart';

class AddToCartModel{
  final int id;
  final bool status;
  final int qty;
  final double price;
  final double total;
  final String? comment;
  ProductModel product;
  CartCustomerModel? cartcustomer;


   AddToCartModel({
    required this.id,
    required this.status,
    required this.qty,
    required this.price,
    required this.total,
    required this.comment,
    required this.product,
    required this.cartcustomer,
  });

  factory AddToCartModel.fromJson(Map<String, dynamic> json) => AddToCartModel(
    id: json['id'],
    status: json['status'] != null ? int.parse(json['status'].toString()) == 1 : false,
    qty: json['quantity'],
    price: json['price'] == null ? 0.0 : double.parse(json['price'].toString()),
    total: json['total'] == null ? 0.0 : double.parse(json['total'].toString()),
    comment: json['comment'],
    product: ProductModel.fromJson(json['products']),
    cartcustomer: json['cart_customer'] == null ? null : CartCustomerModel.fromJson(json['cart_customer']),
  );
}