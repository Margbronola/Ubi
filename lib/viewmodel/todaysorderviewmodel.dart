import 'package:internapp/model/todaysorder_model.dart';
import 'package:rxdart/subjects.dart';

class TodaysOrderViewModel{
  TodaysOrderViewModel._singleton();
  static final TodaysOrderViewModel _instance = TodaysOrderViewModel._singleton();
  static  TodaysOrderViewModel get instance => _instance;
  // ignore: prefer_final_fields
  BehaviorSubject<List<TodaysOrderModel>> _subject = BehaviorSubject<List<TodaysOrderModel>>();
  Stream<List<TodaysOrderModel>> get stream => _subject.stream;
  List<TodaysOrderModel> get current => _subject.value;

  void populate(List<TodaysOrderModel> todayOrder){
    _subject.add(todayOrder);
  }
}