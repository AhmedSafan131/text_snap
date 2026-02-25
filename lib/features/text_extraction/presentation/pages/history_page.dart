import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/history_service.dart';
import '../../domain/entities/extraction_item.dart';
import 'text_extraction_page.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  List<ExtractionItem> _sortedItems(Box<ExtractionItem> box) {
    final items = box.values.toList();
    items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return items;
  }

  Future<void> _deleteItem(String id) async {
    await HistoryService().deleteItem(id);
  }

  Future<void> _clearHistory(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to delete all history?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await HistoryService().clearHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<ExtractionItem>>(
      valueListenable: Hive.box<ExtractionItem>('history_box').listenable(),
      builder: (context, box, _) {
        final items = _sortedItems(box);

        return Scaffold(
          appBar: AppBar(
            title: const Text('History'),
            elevation: 0,
            actions: [
              if (items.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  tooltip: 'Clear History',
                  onPressed: () => _clearHistory(context),
                ),
            ],
          ),
          body: items.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 64, color: AppColors.textHint),
                      SizedBox(height: 16),
                      Text('No history yet', style: TextStyle(fontSize: 18, color: AppColors.textSecondary)),
                      SizedBox(height: 8),
                      Text('Extract text from images to see them here', style: TextStyle(color: AppColors.textHint)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final dateStr = DateFormat('MMM d, y • h:mm a').format(item.timestamp);
                    final previewText = item.extractedText.replaceAll('\n', ' ').trim();

                    return Dismissible(
                      key: Key(item.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => _deleteItem(item.id),
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TextExtractionPage(imagePath: item.imagePath, initialText: item.extractedText),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: File(item.imagePath).existsSync()
                                        ? Image.file(
                                            File(item.imagePath),
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Container(
                                              color: AppColors.surfaceVariant,
                                              child: const Icon(Icons.broken_image, color: AppColors.textHint),
                                            ),
                                          )
                                        : Container(
                                            color: AppColors.surfaceVariant,
                                            child: const Icon(Icons.image_not_supported, color: AppColors.textHint),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        previewText.isNotEmpty ? previewText : 'No text content',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        dateStr,
                                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: AppColors.textHint),
                                  onPressed: () => _deleteItem(item.id),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
