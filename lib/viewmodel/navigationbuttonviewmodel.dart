
import 'package:internapp/global/app.dart';
import 'package:internapp/services/API/datacacher.dart';
import 'package:rxdart/subjects.dart';

class NavigationButtonViewModel{
  NavigationButtonViewModel._singleton();
  static final NavigationButtonViewModel _instance = NavigationButtonViewModel._singleton();
  static NavigationButtonViewModel get instance => _instance;

  final BehaviorSubject<List<int>> _subject = BehaviorSubject<List<int>>.seeded([]);
  Stream<List<int>> get stream => _subject.stream;
  List<int> get current => _subject.value;


  final DataCacher _cacher = DataCacher.instance;
  
  void populate(List<int> nav){
    _subject.add(nav);
  }

  void control(int id){
    List<int> dd = List.from(current);
    if(_isActivated(id)){
      int index = dd.indexOf(id);
      if (currentIndex == index && currentIndex != 0){
        currentIndex = index-1;
      }
      /// remove
      dd.remove(id);
    }
    else{
      /// add id
      dd.add(id);
    }
      _cacher.menuList = dd;
    _subject.add(dd);
  }

  /// Check if id nav bar item is activated
  bool _isActivated(int id)=> current.contains(id);
}