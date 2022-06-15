import 'package:internapp/model/customer_model.dart';
import 'package:rxdart/subjects.dart';

class CustomerViewModel {
  CustomerViewModel._singleton();
  static final CustomerViewModel _instance = CustomerViewModel._singleton();
  static  CustomerViewModel get instance => _instance;
  // ignore: prefer_final_fields
  BehaviorSubject<List<CustomerModel>> _subject = BehaviorSubject<List<CustomerModel>>();
  Stream<List<CustomerModel>> get stream => _subject.stream;
  List<CustomerModel> get current => _subject.value;

  void populate(List<CustomerModel> cus){
    _subject.add(cus);
  }
}