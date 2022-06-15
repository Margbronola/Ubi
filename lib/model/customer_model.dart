class CustomerModel{
  late final int id;
  late final String name;

  CustomerModel(
    {
      required this.id,
      required this.name, 
    });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
    id: json['id'],
    name: json['name'],
  );
}