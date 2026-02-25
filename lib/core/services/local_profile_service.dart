import 'package:hive_flutter/hive_flutter.dart';

class LocalProfileService {
  static const String _boxName = 'profile_box';
  static const String _keyDisplayName = 'display_name';
  static const String _keyProfileImagePath = 'profile_image_path';

  Box get _box => Hive.box(_boxName);

  Future<void> saveDisplayName(String name) async {
    await _box.put(_keyDisplayName, name);
  }

  String? getDisplayName() {
    return _box.get(_keyDisplayName);
  }

  Future<void> saveProfileImagePath(String path) async {
    await _box.put(_keyProfileImagePath, path);
  }

  String? getProfileImagePath() {
    return _box.get(_keyProfileImagePath);
  }

  Future<void> clearProfile() async {
    await _box.delete(_keyDisplayName);
    await _box.delete(_keyProfileImagePath);
  }

  static Future<void> openBox() async {
    await Hive.openBox(_boxName);
  }
}
