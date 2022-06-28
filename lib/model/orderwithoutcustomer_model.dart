// import 'package:internapp/model/orderproduct_model.dart';
// import 'package:internapp/model/payment_model.dart';

// class OrderwithoutCustomerModel{
//   final int id;
//   final bool status;
//   final double total;
//   final int qty;
//   final PaymentModel? payments;
//   final List<OrderProductModel> orderproduct;

//   OrderwithoutCustomerModel({
//     required this.id,
//     required this.status,
//     required this.total,
//     required this.qty,
//     required this.payments,
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

//   factory OrderwithoutCustomerModel.fromJson(Map<String, dynamic> json) => OrderwithoutCustomerModel(
//       id: json['id'],
//       status: json['status'] != null ? int.parse(json['status'].toString()) == 1 : false,
//       total: double.parse(json['total'].toString()),
//       qty: json['order_qty'],
//       payments: json['payments'] == null ? null : PaymentModel.fromJson(json['payments']),
//       orderproduct: orderList(json['order_product'])
//   );
// }