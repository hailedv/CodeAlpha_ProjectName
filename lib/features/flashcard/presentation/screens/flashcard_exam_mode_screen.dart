import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/flashcard_providers.dart';

/// Exam Mode - Answer all questions, then submit at the end
class FlashcardExamModeScreen extends ConsumerStatefulWidget {
  const FlashcardExamModeScreen({super.key});

  @override
  ConsumerState<FlashcardExamModeScreen> createState() =>
      _FlashcardExamModeScreenState();
}

class _FlashcardExamModeScreenState
    extends ConsumerState<FlashcardExamModeScreen> {
  // Store all answers
  final Map<int, TextEditingController> _controllers = {};
  final Map<int, bool> _results = {}; // Store results after grading
  bool _isGraded = false;
  int _correctCount = 0;

  @override
  void initState() {
    super.initState();
    final state = ref.read(flashcardNotifierProvider);
    // Create a controller for each flashcard
    for (int i = 0; i < state.flashcards.length; i++) {
      _controllers[i] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(flashcardNotifierProvider);

    if (state.flashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Exam Mode')),
        body: const Center(child: Text('No flashcards available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Mode'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Column(
              children: [
                Text(
                  _isGraded ? 'Exam Results' : 'Answer All Questions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isGraded
                      ? 'Score: $_correctCount / ${state.flashcards.length}'
                      : 'Total Questions: ${state.flashcards.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (_isGraded) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${(_correctCount / state.flashcards.length * 100).round()}%',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getScoreColor(_correctCount / state.flashcards.length),
                        ),
                  ),
                ],
              ],
            ),
          ),

          // Questions List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.flashcards.length,
              itemBuilder: (context, index) {
                final flashcard = state.flashcards[index];
                final isCorrect = _results[index];
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 3,
                  color: _isGraded
                      ? (isCorrect == true
                          ? Colors.green.shade50
                          : Colors.red.shade50)
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question Number and Status
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _isGraded
                                    ? (isCorrect == true
                                        ? Colors.green
                                        : Colors.red)
                                    : Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: _isGraded
                                    ? Icon(
                                        isCorrect == true
                                            ? Icons.check
                                            : Icons.close,
                                        color: Colors.white,
                                      )
                                    : Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _isGraded
                                    ? (isCorrect == true
                                        ? 'Correct ✓'
                                        : 'Incorrect ✗')
                                    : 'Question ${index + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: _isGraded
                                      ? (isCorrect == true
                                          ? Colors.green.shade700
                                          : Colors.red.shade700)
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Question
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.help_outline, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  flashcard.question,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Answer Input
                        TextField(
                          controller: _controllers[index],
                          enabled: !_isGraded,
                          decoration: InputDecoration(
                            labelText: 'Your Answer',
                            hintText: 'Type your answer here...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: _isGraded
                                ? Colors.grey.shade200
                                : Colors.white,
                            prefixIcon: const Icon(Icons.edit),
                          ),
                          maxLines: 2,
                        ),

                        // Show correct answer after grading
                        if (_isGraded) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.green.shade700,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.lightbulb,
                                  color: Colors.green.shade700,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Correct Answer:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green.shade900,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        flashcard.answer,
                                        style: TextStyle(
                                          color: Colors.green.shade900,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Submit Button (Bottom)
          if (!_isGraded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _submitExam,
                icon: const Icon(Icons.check_circle),
                label: const Text(
                  'Submit All Answers',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

          // Retry Button (After grading)
          if (_isGraded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _retryExam,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry Exam'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _submitExam() {
    final state = ref.read(flashcardNotifierProvider);
    int correct = 0;

    // Grade all answers
    for (int i = 0; i < state.flashcards.length; i++) {
      final userAnswer = _controllers[i]!.text.trim().toLowerCase();
      final correctAnswer = state.flashcards[i].answer.toLowerCase();

      // Check if answer is correct
      final isCorrect = _checkAnswer(userAnswer, correctAnswer);
      _results[i] = isCorrect;

      if (isCorrect) {
        correct++;
      }
    }

    setState(() {
      _correctCount = correct;
      _isGraded = true;
    });

    // Show results dialog
    _showResultsDialog();
  }

  bool _checkAnswer(String userAnswer, String correctAnswer) {
    if (userAnswer.isEmpty) return false;

    // Exact match
    if (userAnswer == correctAnswer) return true;

    // Contains match
    if (correctAnswer.contains(userAnswer) || userAnswer.contains(correctAnswer)) {
      return true;
    }

    // Normalized match (remove punctuation and extra spaces)
    final normalizedUser = userAnswer
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final normalizedCorrect = correctAnswer
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return normalizedUser == normalizedCorrect;
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 0.9) return Colors.green;
    if (percentage >= 0.7) return Colors.blue;
    if (percentage >= 0.5) return Colors.orange;
    return Colors.red;
  }

  void _showResultsDialog() {
    final state = ref.read(flashcardNotifierProvider);
    final percentage = (_correctCount / state.flashcards.length * 100).round();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          '🎉 Exam Complete!',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              percentage >= 90
                  ? Icons.emoji_events
                  : percentage >= 70
                      ? Icons.thumb_up
                      : Icons.sentiment_neutral,
              size: 80,
              color: _getScoreColor(percentage / 100),
            ),
            const SizedBox(height: 20),
            Text(
              'Your Score',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '$_correctCount / ${state.flashcards.length}',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '$percentage%',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: _getScoreColor(percentage / 100),
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Text(
              percentage >= 90
                  ? 'Outstanding! 🌟'
                  : percentage >= 80
                      ? 'Excellent! 🎯'
                      : percentage >= 70
                          ? 'Good job! 👍'
                          : percentage >= 60
                              ? 'Keep practicing! 💪'
                              : 'Try again! 📚',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _retryExam() {
    setState(() {
      _isGraded = false;
      _correctCount = 0;
      _results.clear();
      for (var controller in _controllers.values) {
        controller.clear();
      }
    });
  }
}
