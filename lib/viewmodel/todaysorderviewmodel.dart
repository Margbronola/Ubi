import 'package:internapp/model/order_model.dart';
import 'package:rxdart/subjects.dart';

class TodaysOrderViewModel{
  TodaysOrderViewModel._singleton();
  static final TodaysOrderViewModel _instance = TodaysOrderViewModel._singleton();
  static  TodaysOrderViewModel get instance => _instance;
  // ignore: prefer_final_fields
  BehaviorSubject<List<OrderModel>> _subject = BehaviorSubject<List<OrderModel>>();
  Stream<List<OrderModel>> get stream => _subject.stream;
  List<OrderModel> get current => _subject.value;

  void populate(List<OrderModel> todayOrder){
    _subject.add(todayOrder);
  }
}