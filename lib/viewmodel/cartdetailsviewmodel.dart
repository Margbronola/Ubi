import 'package:internapp/model/cart_model.dart';
import 'package:internapp/model/cartdetails_model.dart';
import 'package:rxdart/subjects.dart';

class CartDetailsViewModel {
  CartDetailsViewModel._singleton();
  static final CartDetailsViewModel _instance = CartDetailsViewModel._singleton();
  static  CartDetailsViewModel get instance => _instance;
  // ignore: prefer_final_fields
  BehaviorSubject<CartModel> _subject = BehaviorSubject<CartModel>();
  Stream<CartModel> get stream => _subject.stream;
  CartModel get current => _subject.value;

  void populate(CartModel order){
    _subject.add(order);
  }

  void add(CartDetailsModel cartModel){
    CartModel copy = current;
    copy.cart.add(cartModel);
    _subject.add(copy);
  }
}