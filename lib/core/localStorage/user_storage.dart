import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static const _userIdKey = 'userId';
  static const _fullNameKey = 'fullName';

  static Future<void> saveUserData(int userId, String fullName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_fullNameKey, fullName);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  static Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fullNameKey);
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_fullNameKey);
  }
}
