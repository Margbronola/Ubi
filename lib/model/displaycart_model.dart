import 'package:internapp/model/product_model.dart';

class DisplayCartModel{
  final int id;
  bool status;
  int qty;
  double price;
  double total;
  ProductModel product;
  String? comment;
  
  DisplayCartModel(
    {
      required this.id,
      required this.status,
      required this.qty,
      required this.price,
      required this.total,
      required this.product,
      required this.comment,
    }
  );

  factory DisplayCartModel.fromJson(Map<String, dynamic> json) => DisplayCartModel(
      id: int.parse(json['id'].toString()),
      status: json['status'] != null ? int.parse(json['status'].toString()) == 1 : false,
      qty: int.parse(json['quantity'].toString()),
      price: double.parse(json['price'].toString()),
      total: double.parse(json['total'].toString()),
      product: ProductModel.fromJson(json['products']),
      comment: json['comment'],
  );
}