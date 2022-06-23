import 'package:internapp/model/product_model.dart';

class ToPrepareModel{
  final int id;
  // final bool status;
  final int qty;
  final ProductModel product;
  final bool prepared;
  final double price;
  final String? comment;


  ToPrepareModel({
    required this.id,
    // required this.status,
    required this.qty,
    required this.prepared,
    required this.product,
    required this.price,
    required this.comment,
  });

  factory ToPrepareModel.fromJson(Map<String, dynamic> json) => ToPrepareModel(
      id: json['id'],
      // status:  json['status'] != null ? int.parse(json['status'].toString()) == 1 : false,
      qty: json['quantity'],
      product: ProductModel.fromJson(json['products']),
      prepared: json['prepared'] != null ? int.parse(json['prepared'].toString()) == 1 : false,
      price:  double.parse(json['price'].toString()),
      comment: json['comment']
  );
}