import 'package:internapp/model/order_model.dart';

class PendingOrderDetailsModel{
  final int id;
  final String name;
  final List<OrderModel> orders;

  PendingOrderDetailsModel({
    required this.id,
    required this.name,
    required this.orders,
  });

  static List<OrderModel> order(List?data){
      List<OrderModel> ff = [];
      if(data != null){
        for(var datum in data){
          ff.add(OrderModel.fromJson(datum));
        }
      }
      return ff;
    }

  factory PendingOrderDetailsModel.fromJson(Map<String, dynamic> json) => PendingOrderDetailsModel(
      id: json['id'],
      name: json['name'],
      orders: order(json['orders'])
  );
}