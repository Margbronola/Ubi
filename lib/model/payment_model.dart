
class PaymentModel{
  final int id;
  final double paid;
  final double change;

  PaymentModel({
    required this.id,
    required this.paid,
    required this.change,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
      id: json['id'],
      paid: double.parse(json['paid'].toString()),
      change: json['change'] == null ? 0.0 : double.parse(json['change'].toString()),
  );
}