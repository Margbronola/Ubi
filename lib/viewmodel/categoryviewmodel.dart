import 'package:internapp/model/category_model.dart';
import 'package:rxdart/subjects.dart';

class CategoryViewModel{
  CategoryViewModel._singleton();
  static final CategoryViewModel _instance = CategoryViewModel._singleton();
  static  CategoryViewModel get instance => _instance;
  // ignore: prefer_final_fields
  BehaviorSubject<List<CategoryModel>> _subject = BehaviorSubject<List<CategoryModel>>();
  Stream<List<CategoryModel>> get stream => _subject.stream;
  List<CategoryModel> get current => _subject.value;

  void populate(List<CategoryModel> category){
    _subject.add(category);
  }
}