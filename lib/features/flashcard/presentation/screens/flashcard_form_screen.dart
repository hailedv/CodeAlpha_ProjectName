import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/flashcard_entity.dart';
import '../providers/flashcard_providers.dart';

/// Form screen for adding/editing flashcards - Simple & Clean
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

  @override
  void initState() {
    super.initState();
    _questionController =
        TextEditingController(text: widget.flashcard?.question ?? '');
    _answerController =
        TextEditingController(text: widget.flashcard?.answer ?? '');
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.flashcard != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Flashcard' : 'Add New Flashcard'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
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
      final isEditing = widget.flashcard != null;

      final flashcard = FlashcardEntity(
        id: widget.flashcard?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        question: _questionController.text.trim(),
        answer: _answerController.text.trim(),
        createdAt: widget.flashcard?.createdAt ?? DateTime.now(),
      );

      if (isEditing) {
        notifier.updateExistingFlashcard(flashcard);
      } else {
        notifier.addNewFlashcard(flashcard);
      }

      // Pop the screen
      Navigator.pop(context);
      
      // Show success message on the previous screen
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditing 
                    ? 'Flashcard updated successfully!' 
                    : 'Flashcard added successfully!',
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      });
    }
  }
}
