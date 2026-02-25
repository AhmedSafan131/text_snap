import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/history_service.dart';
import '../../../../core/utils/text_recognition_service.dart';
import '../bloc/text_extraction_bloc.dart';
import '../bloc/text_extraction_event.dart';
import '../bloc/text_extraction_state.dart';

class TextExtractionPage extends StatelessWidget {
  final String imagePath;
  final String? initialText;

  const TextExtractionPage({super.key, required this.imagePath, this.initialText});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = TextExtractionBloc(
          textRecognitionService: TextRecognitionService(),
          historyService: HistoryService(),
        );
        if (initialText != null) {
          bloc.add(LoadInitialText(imagePath: imagePath, text: initialText!));
        } else {
          bloc.add(ExtractTextFromImage(imagePath));
        }
        return bloc;
      },
      child: _TextExtractionView(imagePath: imagePath),
    );
  }
}

class _TextExtractionView extends StatefulWidget {
  final String imagePath;

  const _TextExtractionView({required this.imagePath});

  @override
  State<_TextExtractionView> createState() => _TextExtractionViewState();
}

class _TextExtractionViewState extends State<_TextExtractionView> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _copyToClipboard() {
    if (_textController.text.isNotEmpty && _textController.text != 'No text found in the image') {
      Clipboard.setData(ClipboardData(text: _textController.text));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Text copied to clipboard'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TextExtractionBloc, TextExtractionState>(
      listener: (context, state) {
        if (state is TextExtractionSuccess) {
          _textController.text = state.text;
        }
      },
      builder: (context, state) {
        final isLoading = state is TextExtractionLoading || state is TextExtractionInitial;
        final successState = state is TextExtractionSuccess ? state : null;
        final hasText =
            successState != null && successState.text.isNotEmpty && successState.text != 'No text found in the image';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Extracted Text'),
            elevation: 0,
            actions: [
              if (hasText) IconButton(icon: const Icon(Icons.copy), onPressed: _copyToClipboard, tooltip: 'Copy text'),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 300,
                  color: Colors.black,
                  child: Image.file(File(widget.imagePath), fit: BoxFit.contain),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Extracted Text',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          if (isLoading)
                            const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (isLoading)
                        const Center(
                          child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()),
                        )
                      else if (state is TextExtractionFailure)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: AppColors.error),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(state.message, style: const TextStyle(color: AppColors.error)),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: TextField(
                            controller: _textController,
                            maxLines: null,
                            style: const TextStyle(fontSize: 16, height: 1.5, color: AppColors.textPrimary),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Extracted text will appear here...',
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),

                      if (hasText)
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _copyToClipboard,
                                icon: const Icon(Icons.copy),
                                label: const Text('Copy Text'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(const SnackBar(content: Text('Share coming soon')));
                                },
                                icon: const Icon(Icons.share),
                                label: const Text('Share'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
