import 'package:internapp/model/image_model.dart';

class ProductModel {
  final int id;
  final String name;
  final String? description;
  final double price;
  final List<ImageModel> images;
  final String reference;
  final int stock;
  final int companyId;
  final bool isService;



  const ProductModel(
    {
      required this.id,
      required this.name, 
      required this.description, 
      required this.price, 
      required this.images,
      required this.reference,
      required this.stock,
      required this.companyId,
      required this.isService,
    });

    static List<ImageModel> imageConvert(List?data){
      List<ImageModel> ff = [];
      if(data != null){
        for(var datum in data){
          ff.add(ImageModel.fromJson(datum));
        }
      }
      return ff;
    }
    
    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'] == null ? 0.0 : double.parse(json['price'].toString()),
      images: imageConvert(json['images']),
      reference: json['reference'],
      stock: json['stock'],
      companyId: int.parse(json['company_id'].toString()),
      isService: json['is_service'] != null ? int.parse(json['is_service'].toString()) == 1 : false,
  );

}
