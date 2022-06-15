import 'package:internapp/model/orders_model.dart';
import 'package:rxdart/subjects.dart';

class OrdersViewModel {
  OrdersViewModel._singleton();
  static final OrdersViewModel _instance = OrdersViewModel._singleton();
  static  OrdersViewModel get instance => _instance;
  // ignore: prefer_final_fields
  BehaviorSubject<List<OrdersModel>> _subject = BehaviorSubject<List<OrdersModel>>();
  Stream<List<OrdersModel>> get stream => _subject.stream;
  List<OrdersModel> get current => _subject.value;

  void populate(List<OrdersModel> orders){
    _subject.add(orders);
  }
}