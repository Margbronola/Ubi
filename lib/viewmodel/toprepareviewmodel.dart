
import 'package:internapp/model/toprepare_model.dart';
import 'package:rxdart/rxdart.dart';

class ToPrepareViewModel{
  ToPrepareViewModel._singleton();
  static final ToPrepareViewModel _instance = ToPrepareViewModel._singleton();
  static  ToPrepareViewModel get instance => _instance;
  // ignore: prefer_final_fields
  BehaviorSubject<List<ToPrepareModel>> _subject = BehaviorSubject<List<ToPrepareModel>>();
  Stream<List<ToPrepareModel>> get stream => _subject.stream;
  List<ToPrepareModel> get current => _subject.value;

  void populate(List<ToPrepareModel> prepare){
    _subject.add(prepare);
  }
}