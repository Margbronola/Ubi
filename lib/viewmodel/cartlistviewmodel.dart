import 'package:internapp/model/cartlist_model.dart';
import 'package:rxdart/subjects.dart';

class CartListViewModel{
  CartListViewModel._singleton();
  static final CartListViewModel _instance = CartListViewModel._singleton();
  static  CartListViewModel get instance => _instance;
  // ignore: prefer_final_fields
  BehaviorSubject<CartListModel> _subject = BehaviorSubject<CartListModel>();
  Stream<CartListModel> get stream => _subject.stream;
  CartListModel get current => _subject.value;

  void populate(CartListModel cartList){
    _subject.add(cartList);
  }
}