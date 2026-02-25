part of 'extraction_item.dart';

class ExtractionItemAdapter extends TypeAdapter<ExtractionItem> {
  @override
  final int typeId = 0;

  @override
  ExtractionItem read(BinaryReader reader) {
    return ExtractionItem(
      id: reader.readString(),
      imagePath: reader.readString(),
      extractedText: reader.readString(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
    );
  }

  @override
  void write(BinaryWriter writer, ExtractionItem obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.imagePath);
    writer.writeString(obj.extractedText);
    writer.writeInt(obj.timestamp.millisecondsSinceEpoch);
  }
}
