import 'package:internapp/model/user_model.dart';
import 'package:rxdart/subjects.dart';

class UserViewModel {
  UserViewModel._singleton();
  static final UserViewModel _instance = UserViewModel._singleton();
  static  UserViewModel get instance => _instance;
  // ignore: prefer_final_fields
  BehaviorSubject<List<UserModel>> _subject = BehaviorSubject<List<UserModel>>();
  Stream<List<UserModel>> get stream => _subject.stream;
  List<UserModel> get current => _subject.value;

  void populate(List<UserModel> user){
    _subject.add(user);
  }
}