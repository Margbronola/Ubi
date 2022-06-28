import 'package:internapp/model/cartcustomer_model.dart';
import 'package:internapp/model/payment_model.dart';

class TodaysOrderModel{
  final int id;
  final bool status;
  final double total;
  final int orderQty;
  final PaymentModel? payment;
  final CartCustomerModel cartCustomer;


  TodaysOrderModel({
    required this.id,
    required this.status,
    required this.total,
    required this.orderQty,
    required this.payment,
    required this.cartCustomer
  });

  factory TodaysOrderModel.fromJson(Map<String, dynamic> json) => TodaysOrderModel(
    id: json['id'],
    status: json['status'] != null ? int.parse(json['status'].toString()) == 1 : false,
    total: double.parse(json['total'].toString()),
    orderQty: json['order_qty'],
    payment: json['payments'] == null ? null : PaymentModel.fromJson(json['payments']),
    cartCustomer: CartCustomerModel.fromJson(json['cart_customer']),
  );
}