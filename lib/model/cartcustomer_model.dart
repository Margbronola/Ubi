import 'package:internapp/model/customer_model.dart';

class CartCustomerModel{
  final int id;
  CustomerModel? customer; 


   CartCustomerModel({
    required this.id,
    required this.customer,
  });

  factory CartCustomerModel.fromJson(Map<String, dynamic> json) => CartCustomerModel(
      id: json['id'],
      customer: json['customer'] == null ? null : CustomerModel.fromJson(json['customer']),
  );
}