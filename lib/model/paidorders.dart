// import 'package:internapp/model/customer_model.dart';
// import 'package:internapp/model/orderproduct_model.dart';
// import 'package:internapp/model/payment_model.dart';

// class PaidOrderModel{
//   final int id;
//   final double total;
//   final int qty;
//   final PaymentModel payment;
//   final CustomerModel customer;
//   final List<OrderProductModel> orderproduct;

//   PaidOrderModel({
//     required this.id,
//     required this.total,
//     required this.qty,
//     required this.payment,
//     required this.customer,
//     required this.orderproduct
//   });

//   static List<OrderProductModel> orderList(List?data){
//       List<OrderProductModel> ff = [];
//       if(data != null){
//         for(var datum in data){
//           ff.add(OrderProductModel.fromJson(datum));
//         }
//       }
//       return ff;
//     }

//   factory PaidOrderModel.fromJson(Map<String, dynamic> json) => PaidOrderModel(
//       id: json['id'],
//       total: json['total'],
//       qty: json['order_qty'],
//       payment: PaymentModel.fromJson(json['payments']),
//       customer: CustomerModel.fromJson(json['customers']),
//       orderproduct: orderList(json['order_product'])
//   );
// }