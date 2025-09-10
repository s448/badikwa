import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static const _userIdKey = 'userId';
  static const _fullNameKey = 'fullName';
  static const _emailKey = 'email';

  static Future<void> saveUserData(
    int userId,
    String fullName,
    String email,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_fullNameKey, fullName);
    await prefs.setString(_emailKey, email);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  static Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fullNameKey);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_fullNameKey);
    await prefs.remove(_emailKey);
  }
}
