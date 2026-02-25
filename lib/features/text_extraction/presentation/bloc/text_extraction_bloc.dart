import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/history_service.dart';
import '../../../../core/utils/text_recognition_service.dart';
import '../../domain/entities/extraction_item.dart';
import 'text_extraction_event.dart';
import 'text_extraction_state.dart';

class TextExtractionBloc extends Bloc<TextExtractionEvent, TextExtractionState> {
  final TextRecognitionService textRecognitionService;
  final HistoryService historyService;

  TextExtractionBloc({required this.textRecognitionService, required this.historyService})
    : super(const TextExtractionInitial()) {
    on<ExtractTextFromImage>(_onExtractTextFromImage);
    on<LoadInitialText>(_onLoadInitialText);
  }

  Future<void> _onExtractTextFromImage(ExtractTextFromImage event, Emitter<TextExtractionState> emit) async {
    emit(const TextExtractionLoading());
    try {
      final text = await textRecognitionService.extractTextFromImage(event.imagePath);

      final extractedText = text.isEmpty ? 'No text found in the image' : text;
      emit(TextExtractionSuccess(imagePath: event.imagePath, text: extractedText));

      if (text.isNotEmpty) {
        await historyService.saveItem(
          ExtractionItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            imagePath: event.imagePath,
            extractedText: text,
            timestamp: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      emit(TextExtractionFailure('Error extracting text: ${e.toString()}'));
    }
  }

  void _onLoadInitialText(LoadInitialText event, Emitter<TextExtractionState> emit) {
    emit(TextExtractionSuccess(imagePath: event.imagePath, text: event.text));
  }

  @override
  Future<void> close() {
    textRecognitionService.dispose();
    return super.close();
  }
}
