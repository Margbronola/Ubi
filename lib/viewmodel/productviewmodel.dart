import 'package:internapp/model/product_model.dart';
import 'package:rxdart/subjects.dart';

class ProductViewModel {
  ProductViewModel._singleton();
  static final ProductViewModel _instance = ProductViewModel._singleton();
  static  ProductViewModel get instance => _instance;
  // ignore: prefer_final_fields
  BehaviorSubject<List<ProductModel>> _subject = BehaviorSubject<List<ProductModel>>();
  Stream<List<ProductModel>> get stream => _subject.stream;
  List<ProductModel> get current => _subject.value;

  void populate(List<ProductModel> prod){
    _subject.add(prod);
  }
}