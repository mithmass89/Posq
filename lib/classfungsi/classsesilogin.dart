import 'package:shared_preferences/shared_preferences.dart';

class LoginSession {
  // Key constants for storing data in SharedPreferences
  static const String isLoggedInKey = 'isLoggedIn';
  static const String emailKey = 'email';
  static const String passwordKey = 'password';
  static const String databaseNameKey = 'databaseName';
  static const String codeOutletKey = 'codeOutlet';

  // Function to check if the user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoggedInKey) ?? false;
  }

  // Function to store login information
  static Future<void> saveLoginInfo(
    String email,
    String password,
    String databaseName,
    String codeOutlet,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(isLoggedInKey, true);
    prefs.setString(emailKey, email);
    prefs.setString(passwordKey, password);
    prefs.setString(databaseNameKey, databaseName);
    prefs.setString(codeOutletKey, codeOutlet);
  }

  // Function to get the stored email
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.containsKey(emailKey));
    if (prefs.containsKey(emailKey)) {
      return prefs.getString(emailKey);
    } else {
      return '';
    }
  }

  // Function to get the stored password
  static Future<String?> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(passwordKey)) {
      return prefs.getString(passwordKey);
    } else {
      return '';
    }
  }

  // Function to get the stored database name
  static Future<String?> getDatabaseName() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(databaseNameKey)) {
      return prefs.getString(databaseNameKey);
    } else {
      return '';
    }
  }

  // Function to get the stored code outlet
  static Future<String?> getCodeOutlet() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(codeOutletKey)) {
      return prefs.getString(codeOutletKey);
    } else {
      return "";
    }
  }

  // Function to clear login information (logout)
  static Future<void> clearLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(isLoggedInKey, false);
    prefs.remove(emailKey);
    prefs.remove(passwordKey);
    prefs.remove(databaseNameKey);
    prefs.remove(codeOutletKey);
  }
}
