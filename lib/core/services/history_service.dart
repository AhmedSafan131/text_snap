import 'package:hive_flutter/hive_flutter.dart';
import '../../features/text_extraction/domain/entities/extraction_item.dart';

class HistoryService {
  static const String _boxName = 'history_box';

  Box<ExtractionItem> get _box => Hive.box<ExtractionItem>(_boxName);

  Future<void> saveItem(ExtractionItem item) async {
    await _box.put(item.id, item);
  }

  List<ExtractionItem> getHistory() {
    final items = _box.values.toList();
    items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return items;
  }

  Future<void> deleteItem(String id) async {
    await _box.delete(id);
  }

  Future<void> clearHistory() async {
    await _box.clear();
  }

  static Future<void> openBox() async {
    await Hive.openBox<ExtractionItem>(_boxName);
  }
}
