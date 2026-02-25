import 'package:hive/hive.dart';

part 'extraction_item.g.dart';

@HiveType(typeId: 0)
class ExtractionItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String imagePath;

  @HiveField(2)
  final String extractedText;

  @HiveField(3)
  final DateTime timestamp;

  ExtractionItem({required this.id, required this.imagePath, required this.extractedText, required this.timestamp});
}
