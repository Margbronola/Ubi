

class UserModel {
  final int id;
   String name;
  late final String email;
   String phone;
  final String position;
  final int status;
  final int companyId;
  final DateTime createdAt;

   UserModel(
    {
      required this.id, 
      required this.name, 
      required this.email, 
      required this.phone, 
      required this.position, 
      required this.status, 
      required this.companyId, 
      required this.createdAt, 
    });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      position: json['position'],
      status: json['status'],
      companyId: json['company_id'],
      createdAt: DateTime.parse(json['created_at']),
  );
}
