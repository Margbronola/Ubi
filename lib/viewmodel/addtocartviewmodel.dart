import 'package:internapp/model/addtocart_model.dart';
import 'package:rxdart/subjects.dart';

class AddToCartViewModel {
  AddToCartViewModel._singleton();
  static final AddToCartViewModel _instance = AddToCartViewModel._singleton();
  static  AddToCartViewModel get instance => _instance;
  // ignore: prefer_final_fields
  BehaviorSubject<AddToCartModel> _subject = BehaviorSubject<AddToCartModel>();
  Stream<AddToCartModel> get stream => _subject.stream;
  AddToCartModel get current => _subject.value;

  void populate(AddToCartModel order){
    _subject.add(order);
  }
}