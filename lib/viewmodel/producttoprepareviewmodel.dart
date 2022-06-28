import 'package:internapp/model/producttoprepare_model.dart';
import 'package:rxdart/rxdart.dart';

class ProductToPrepareViewModel{
  ProductToPrepareViewModel._singleton();
  static final ProductToPrepareViewModel _instance = ProductToPrepareViewModel._singleton();
  static  ProductToPrepareViewModel get instance => _instance;
  // ignore: prefer_final_fields
  BehaviorSubject<List<ProductToPrepareModel>> _subject = BehaviorSubject<List<ProductToPrepareModel>>();
  Stream<List<ProductToPrepareModel>> get stream => _subject.stream;
  List<ProductToPrepareModel> get current => _subject.value;

  void populate(List<ProductToPrepareModel> prepare){
    _subject.add(prepare);
  }
}