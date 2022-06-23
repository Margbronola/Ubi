// ignore_for_file: file_names

import 'package:internapp/model/order_model.dart';
import 'package:rxdart/subjects.dart';

class OrdersDetailsViewModel {
  OrdersDetailsViewModel._singleton();
  static final OrdersDetailsViewModel _instance = OrdersDetailsViewModel._singleton();
  static  OrdersDetailsViewModel get instance => _instance;
  // ignore: prefer_final_fields
  BehaviorSubject<OrderModel> _subject = BehaviorSubject<OrderModel>();
  Stream<OrderModel> get stream => _subject.stream;
  OrderModel get current => _subject.value;

  void populate(OrderModel order){
    _subject.add(order);
  }

  void add(OrderModel cartModel){
    _subject.add(cartModel);
  }
}