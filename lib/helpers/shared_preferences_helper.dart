import 'package:myapp/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _userIdKey = 'userId';
  static const String _userFirstNameKey = 'userFirstName';
  static const String _userLastNameKey = 'userLastName';
  static const String _userEmailKey = 'userEmail';

  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, user.id!);
    await prefs.setString(_userFirstNameKey, user.firstName);
    await prefs.setString(_userLastNameKey, user.lastName);
    await prefs.setString(_userEmailKey, user.email);
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final int? id = prefs.getInt(_userIdKey);
    final String? firstName = prefs.getString(_userFirstNameKey);
    final String? lastName = prefs.getString(_userLastNameKey);
    final String? email = prefs.getString(_userEmailKey);

    if (id != null && firstName != null && lastName != null && email != null) {
      return User(
        id: id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: '',
      );
    }
    return null;
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_userFirstNameKey);
    await prefs.remove(_userLastNameKey);
    await prefs.remove(_userEmailKey);
  }
}
