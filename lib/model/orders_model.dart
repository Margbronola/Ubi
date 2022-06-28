class OrdersModel{
  final int id;
  final bool status;
  final double total;
  final int orderQty;

  OrdersModel({
    required this.id,
    required this.status,
    required this.total,
    required this.orderQty
  });

  factory OrdersModel.fromJson(Map<String, dynamic> json) => OrdersModel(
    id: json['id'],
    status: json['status'] != null ? int.parse(json['status'].toString()) == 1 : false,
    total: double.parse(json['total'].toString()),
    orderQty: json['order_qty'],
  );
}