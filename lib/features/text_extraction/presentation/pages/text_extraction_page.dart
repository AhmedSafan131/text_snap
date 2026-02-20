import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/text_recognition_service.dart';
import '../../../../core/services/history_service.dart';
import '../../domain/entities/extraction_item.dart';

class TextExtractionPage extends StatefulWidget {
  final String imagePath;
  final String? initialText;

  const TextExtractionPage({super.key, required this.imagePath, this.initialText});

  @override
  State<TextExtractionPage> createState() => _TextExtractionPageState();
}

class _TextExtractionPageState extends State<TextExtractionPage> {
  final TextRecognitionService _textRecognitionService = TextRecognitionService();
  final TextEditingController _textController = TextEditingController();
  String _extractedText = '';
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.initialText != null) {
      _extractedText = widget.initialText!;
      _textController.text = _extractedText;
      _isLoading = false;
    } else {
      _extractText();
    }
  }

  Future<void> _extractText() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final text = await _textRecognitionService.extractTextFromImage(widget.imagePath);

      if (mounted) {
        setState(() {
          _extractedText = text.isEmpty ? 'No text found in the image' : text;
          _textController.text = _extractedText;
          _isLoading = false;
        });

        if (text.isNotEmpty) {
          try {
            final historyService = HistoryService();
            await historyService.saveItem(
              ExtractionItem(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                imagePath: widget.imagePath,
                extractedText: text,
                timestamp: DateTime.now(),
              ),
            );
          } catch (e) {
            print('Failed to save to history: $e');
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error extracting text: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
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
  void dispose() {
    _textRecognitionService.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extracted Text'),
        elevation: 0,
        actions: [
          if (!_isLoading && _extractedText.isNotEmpty && _extractedText != 'No text found in the image')
            IconButton(icon: const Icon(Icons.copy), onPressed: _copyToClipboard, tooltip: 'Copy text'),
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
                      if (_isLoading)
                        const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (_isLoading)
                    const Center(
                      child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()),
                    )
                  else if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.error.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.error),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(_errorMessage!, style: const TextStyle(color: AppColors.error)),
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

                  if (!_isLoading && _extractedText.isNotEmpty && _extractedText != 'No text found in the image')
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
                              // TODO: Implement share functionality
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
  }
}
