import 'package:internapp/model/customer_model.dart';
import 'package:internapp/model/orderproduct_model.dart';
import 'package:internapp/model/payment_model.dart';

class OrdersModel{
  final int id;
  final bool status;
  final double total;
  final int qty;
  final DateTime date;
  final CustomerModel customer;
  final PaymentModel payments;
  final List<OrderProductModel> orderproduct;

  OrdersModel({
      required this.id,
      required this.status,
      required this.total,
      required this.qty,
      required this.date,
      required this.customer,
      required this.payments,
      required this.orderproduct
  });

    static List<OrderProductModel> orderList(List?data){
      List<OrderProductModel> ff = [];
      if(data != null){
        for(var datum in data){
          ff.add(OrderProductModel.fromJson(datum));
        }
      }
      return ff;
    }

  factory OrdersModel.fromJson(Map<String, dynamic> json) => OrdersModel(
      id: json['id'],
      status: json['status'] != null ? int.parse(json['status'].toString()) == 1 : false,
      total: double.parse(json['total'].toString()),
      qty: json['order_qty'],
      date: DateTime.parse(json['created_at']),
      customer: CustomerModel.fromJson(json['customers']),
      payments: PaymentModel.fromJson(json['payments']),
      orderproduct: orderList(json['order_product'])
  );
}