import 'package:internapp/model/pendingorderdetails_model.dart';
import 'package:rxdart/subjects.dart';


class PendingOrderDetailsViewModel{
  PendingOrderDetailsViewModel._singleton();
  static final PendingOrderDetailsViewModel _instance = PendingOrderDetailsViewModel._singleton();
  static  PendingOrderDetailsViewModel get instance => _instance;
  // ignore: prefer_final_fields
  BehaviorSubject<List<PendingOrderDetailsModel>> _subject = BehaviorSubject<List<PendingOrderDetailsModel>>();
  Stream<List<PendingOrderDetailsModel>> get stream => _subject.stream;
  List<PendingOrderDetailsModel> get current => _subject.value;

  void populate(List<PendingOrderDetailsModel> pendingList){
    _subject.add(pendingList);
  }
}