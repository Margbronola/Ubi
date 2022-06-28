import 'package:internapp/model/order_model.dart';
import 'package:rxdart/subjects.dart';

class OrderViewModel{
  OrderViewModel._singleton();
  static final OrderViewModel _instance = OrderViewModel._singleton();
  static  OrderViewModel get instance => _instance;
  // ignore: prefer_final_fields
  BehaviorSubject<List<OrderModel>> _subject = BehaviorSubject<List<OrderModel>>();
  Stream<List<OrderModel>> get stream => _subject.stream;
  List<OrderModel> get current => _subject.value;

  void populate(List<OrderModel> todayOrder){
    _subject.add(todayOrder);
  }
}