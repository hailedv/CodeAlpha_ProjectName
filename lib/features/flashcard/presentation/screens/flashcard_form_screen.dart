import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/flashcard_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../providers/flashcard_providers.dart';

/// Form screen for adding/editing flashcards
class FlashcardFormScreen extends ConsumerStatefulWidget {
  final FlashcardEntity? flashcard;

  const FlashcardFormScreen({super.key, this.flashcard});

  @override
  ConsumerState<FlashcardFormScreen> createState() =>
      _FlashcardFormScreenState();
}

class _FlashcardFormScreenState extends ConsumerState<FlashcardFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _questionController;
  late TextEditingController _answerController;
  late TextEditingController _hintController;
  late String _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _questionController =
        TextEditingController(text: widget.flashcard?.question ?? '');
    _answerController =
        TextEditingController(text: widget.flashcard?.answer ?? '');
    _hintController =
        TextEditingController(text: widget.flashcard?.hint ?? '');
    _selectedCategoryId = widget.flashcard?.categoryId ?? 'general';
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    _hintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.flashcard != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Flashcard' : 'Add Flashcard'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Category Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.category, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Category',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: Categories.all.map((category) {
                        final isSelected = _selectedCategoryId == category.id;
                        return ChoiceChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                category.icon,
                                size: 18,
                                color: isSelected ? Colors.white : category.color,
                              ),
                              const SizedBox(width: 6),
                              Text(category.name),
                            ],
                          ),
                          selected: isSelected,
                          selectedColor: category.color,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategoryId = category.id;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Question Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.help_outline, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Question',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _questionController,
                      decoration: const InputDecoration(
                        hintText: 'Type your question here...',
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                      maxLines: 4,
                      style: const TextStyle(fontSize: 16),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a question';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Answer Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Answer',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _answerController,
                      decoration: const InputDecoration(
                        hintText: 'Write your answer clearly here...',
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                      maxLines: 6,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an answer';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Hint Section (Optional)
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.tips_and_updates_outlined, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'Hint (Optional)',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.grey[700],
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _hintController,
                      decoration: const InputDecoration(
                        hintText: 'Add a helpful hint...',
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                      maxLines: 3,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Save Button
            ElevatedButton.icon(
              onPressed: _saveFlashcard,
              icon: const Icon(Icons.save_rounded),
              label: Text(
                isEditing ? 'Update Flashcard' : 'Save Flashcard',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveFlashcard() {
    if (_formKey.currentState!.validate()) {
      final notifier = ref.read(flashcardNotifierProvider.notifier);

      final flashcard = FlashcardEntity(
        id: widget.flashcard?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        question: _questionController.text.trim(),
        answer: _answerController.text.trim(),
        categoryId: _selectedCategoryId,
        hint: _hintController.text.trim().isEmpty
            ? null
            : _hintController.text.trim(),
        createdAt: widget.flashcard?.createdAt ?? DateTime.now(),
      );

      if (widget.flashcard == null) {
        notifier.addNewFlashcard(flashcard);
      } else {
        notifier.updateExistingFlashcard(flashcard);
      }

      Navigator.pop(context);
    }
  }
}
