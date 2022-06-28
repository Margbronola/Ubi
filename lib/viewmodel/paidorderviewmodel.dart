// import 'package:internapp/model/paidorders.dart';
// import 'package:rxdart/subjects.dart';

// class PaidOrderViewModel{
//   PaidOrderViewModel._singleton();
//   static final PaidOrderViewModel _instance = PaidOrderViewModel._singleton();
//   static  PaidOrderViewModel get instance => _instance;
//   // ignore: prefer_final_fields
//   BehaviorSubject<List<PaidOrderModel>> _subject = BehaviorSubject<List<PaidOrderModel>>();
//   Stream<List<PaidOrderModel>> get stream => _subject.stream;
//   List<PaidOrderModel> get current => _subject.value;

//   void populate(List<PaidOrderModel> paidOrder){
//     _subject.add(paidOrder);
//   }
// }