import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static Future<void> saveLoginSession(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedInUser', username);
  }

  static Future<void> saveRole(int role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userRole', role);
  }
  
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> saveUserData(
      int user_id, String username, String token, int level) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', user_id);
    await prefs.setString('username', username);
    await prefs.setString('token', token);
    await prefs.setInt('level', level);
  }

  static Future<Map<String, String?>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? token = prefs.getString('token');
    int? level = prefs.getInt('level');
    int? user_id = prefs.getInt('user_id');

    return {
      'username': username,
      'token': token,
      'user_id': user_id.toString(),
      'level': level.toString(),
    };
  }

  static Future<void> clearSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
