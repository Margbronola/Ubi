import 'package:shared_preferences/shared_preferences.dart';

class DataCacher{
  DataCacher._singleton();
  static DataCacher get _instance => DataCacher._singleton();
  static late final SharedPreferences _sharedPreferences;
  static DataCacher get instance => _instance;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  set uToken(String? token){
    _sharedPreferences.setString("accessToken", token!);
  }
  
  String? get uToken => _sharedPreferences.getString('accessToken');

  set menuList(List<int> menuIds){
    List<String> _converted = menuIds.map((e) => e.toString()).toList();
    _sharedPreferences.setStringList("menu_ids", _converted);
  }

  List<int> get menuList {
    List<String> data = _sharedPreferences.getStringList('menu_ids') ?? [];
    // ignore: avoid_print
    print(data);
    return data.map((e) => int.parse(e)).toList();
  }
  
}