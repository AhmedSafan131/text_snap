import 'package:equatable/equatable.dart';

abstract class TextExtractionState extends Equatable {
  const TextExtractionState();

  @override
  List<Object?> get props => [];
}

class TextExtractionInitial extends TextExtractionState {
  const TextExtractionInitial();
}

class TextExtractionLoading extends TextExtractionState {
  const TextExtractionLoading();
}

class TextExtractionSuccess extends TextExtractionState {
  final String imagePath;
  final String text;

  const TextExtractionSuccess({required this.imagePath, required this.text});

  @override
  List<Object?> get props => [imagePath, text];
}

class TextExtractionFailure extends TextExtractionState {
  final String message;

  const TextExtractionFailure(this.message);

  @override
  List<Object?> get props => [message];
}
