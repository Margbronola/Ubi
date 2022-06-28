import 'package:internapp/model/displaycart_model.dart';
import 'package:rxdart/subjects.dart';

class CartDetailsViewModel{
  CartDetailsViewModel._singleton();
  static final CartDetailsViewModel _instance = CartDetailsViewModel._singleton();
  static  CartDetailsViewModel get instance => _instance;
  // ignore: prefer_final_fields
  BehaviorSubject<DisplayCartModel> _subject = BehaviorSubject<DisplayCartModel>();
  Stream<DisplayCartModel> get stream => _subject.stream;
  DisplayCartModel get current => _subject.value;

  void populate(DisplayCartModel order){
    _subject.add(order);
  }
}