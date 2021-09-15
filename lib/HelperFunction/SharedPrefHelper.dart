import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String tokenKey = "TOKEN";
  static String usernameKey = "USERNAMEKEY";
  static String emailKey = "EMAILKEY";

  //save data
  Future<bool> saveToken(String getToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(tokenKey, getToken);
  }

  // get data
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }
}
