import 'package:shared_preferences/shared_preferences.dart';

class LocalProfileService {
  static const String _keyDisplayName = 'user_display_name';
  static const String _keyProfileImagePath = 'user_profile_image_path';

  Future<void> saveDisplayName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDisplayName, name);
  }

  Future<String?> getDisplayName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDisplayName);
  }

  Future<void> saveProfileImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProfileImagePath, path);
  }

  Future<String?> getProfileImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyProfileImagePath);
  }

  Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyDisplayName);
    await prefs.remove(_keyProfileImagePath);
  }
}
