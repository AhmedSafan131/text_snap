import 'package:equatable/equatable.dart';

abstract class TextExtractionEvent extends Equatable {
  const TextExtractionEvent();

  @override
  List<Object?> get props => [];
}

class ExtractTextFromImage extends TextExtractionEvent {
  final String imagePath;

  const ExtractTextFromImage(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class LoadInitialText extends TextExtractionEvent {
  final String imagePath;
  final String text;

  const LoadInitialText({required this.imagePath, required this.text});

  @override
  List<Object?> get props => [imagePath, text];
}
