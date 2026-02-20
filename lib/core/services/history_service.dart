import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/text_extraction/domain/entities/extraction_item.dart';

class HistoryService {
  static const String _historyKey = 'extraction_history';

  Future<void> saveItem(ExtractionItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> historyJson = prefs.getStringList(_historyKey) ?? [];

    historyJson.insert(0, jsonEncode(item.toJson()));

    await prefs.setStringList(_historyKey, historyJson);
  }

  Future<List<ExtractionItem>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> historyJson = prefs.getStringList(_historyKey) ?? [];

    return historyJson.map((itemJson) => ExtractionItem.fromJson(jsonDecode(itemJson))).toList();
  }

  Future<void> deleteItem(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historyJson = prefs.getStringList(_historyKey) ?? [];

    historyJson.removeWhere((itemJson) {
      final item = ExtractionItem.fromJson(jsonDecode(itemJson));
      return item.id == id;
    });

    await prefs.setStringList(_historyKey, historyJson);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
