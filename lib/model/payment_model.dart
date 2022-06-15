
class PaymentModel{
  final int id;
  final double total;
  final double paid;
  final double change;

  PaymentModel({
    required this.id,
    required this.total,
    required this.paid,
    required this.change,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
      id: json['id'],
      total: json['total'] == null ? 0.0 : double.parse(json['total'].toString()),
      paid: double.parse(json['paid'].toString()),
      // json['paid'] == null ? 0.0 : 
      change: json['change'] == null ? 0.0 : double.parse(json['change'].toString()),
  );
}