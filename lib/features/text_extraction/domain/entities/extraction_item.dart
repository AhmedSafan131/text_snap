class ExtractionItem {
  final String id;
  final String imagePath;
  final String extractedText;
  final DateTime timestamp;

  ExtractionItem({required this.id, required this.imagePath, required this.extractedText, required this.timestamp});

  Map<String, dynamic> toJson() {
    return {'id': id, 'imagePath': imagePath, 'extractedText': extractedText, 'timestamp': timestamp.toIso8601String()};
  }

  factory ExtractionItem.fromJson(Map<String, dynamic> json) {
    return ExtractionItem(
      id: json['id'],
      imagePath: json['imagePath'],
      extractedText: json['extractedText'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
