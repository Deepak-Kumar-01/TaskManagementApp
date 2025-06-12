import 'package:shared_preferences/shared_preferences.dart';

class PrefManager {
  PrefManager._();
  static final PrefManager db = PrefManager._();

  SharedPreferences? _preferences;

  init() async {
    if (_preferences != null) {
      return _preferences;
    }
    _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  //getter loggedIn
  bool get isLoggedIn => _preferences?.getBool("isLoggedIn") ?? false;
  //set logIn status
  setIsLoggedIn(bool value) async {
    await _preferences!.setBool("isLoggedIn", value);
  }

  //getter isOnboarded status
  bool get isOnboarded => _preferences?.getBool("isOnboarded")??false;
  //set isOnboarded Status
  setIsOnboarded(bool value)async{
    await _preferences?.setBool("isOnboarded", value);
  }
  Future<bool> clearAll() async {
    return await _preferences!.clear();
  }
}