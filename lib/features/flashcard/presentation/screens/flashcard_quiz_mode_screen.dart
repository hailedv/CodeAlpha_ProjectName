import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/flashcard_providers.dart';
import '../providers/flashcard_state.dart';

/// Interactive Quiz Mode - User answers questions
class FlashcardQuizModeScreen extends ConsumerStatefulWidget {
  const FlashcardQuizModeScreen({super.key});

  @override
  ConsumerState<FlashcardQuizModeScreen> createState() =>
      _FlashcardQuizModeScreenState();
}

class _FlashcardQuizModeScreenState
    extends ConsumerState<FlashcardQuizModeScreen> {
  final TextEditingController _answerController = TextEditingController();
  bool _hasSubmitted = false;
  bool _isCorrect = false;
  int _correctCount = 0;
  int _totalAnswered = 0;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(flashcardNotifierProvider);
    final notifier = ref.read(flashcardNotifierProvider.notifier);

    if (state.flashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz Mode')),
        body: const Center(child: Text('No flashcards available')),
      );
    }

    final currentCard = state.currentFlashcard!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Mode'),
        centerTitle: true,
        actions: [
          // Score Display
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Score: $_correctCount/$_totalAnswered',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress
            Text(
              'Question ${state.currentIndex + 1} of ${state.flashcards.length}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (state.currentIndex + 1) / state.flashcards.length,
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
            const SizedBox(height: 32),

            // Question Card
            Card(
              elevation: 4,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentCard.question,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Answer Input
            if (!_hasSubmitted) ...[
              Text(
                'Your Answer:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _answerController,
                decoration: InputDecoration(
                  hintText: 'Type your answer here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  prefixIcon: const Icon(Icons.edit),
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton.icon(
                onPressed: _answerController.text.trim().isEmpty
                    ? null
                    : _submitAnswer,
                icon: const Icon(Icons.check_circle),
                label: const Text(
                  'Submit Answer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],

            // Result Display
            if (_hasSubmitted) ...[
              // Result Card
              Card(
                elevation: 4,
                color: _isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        _isCorrect ? Icons.check_circle : Icons.cancel,
                        size: 64,
                        color: _isCorrect ? Colors.green : Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _isCorrect ? 'Correct!' : 'Incorrect',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                            ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Your Answer
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Answer:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _answerController.text,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Correct Answer
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.green.shade700,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Correct Answer:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade900,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currentCard.answer,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green.shade900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Next Question Button
              ElevatedButton.icon(
                onPressed: _nextQuestion,
                icon: const Icon(Icons.arrow_forward),
                label: Text(
                  state.currentIndex < state.flashcards.length - 1
                      ? 'Next Question'
                      : 'Finish Quiz',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _submitAnswer() {
    final state = ref.read(flashcardNotifierProvider);
    final currentCard = state.currentFlashcard!;
    final userAnswer = _answerController.text.trim().toLowerCase();
    final correctAnswer = currentCard.answer.toLowerCase();

    // Check if answer is correct (case-insensitive, partial match)
    final isCorrect = correctAnswer.contains(userAnswer) ||
        userAnswer.contains(correctAnswer) ||
        _normalizeAnswer(userAnswer) == _normalizeAnswer(correctAnswer);

    setState(() {
      _hasSubmitted = true;
      _isCorrect = isCorrect;
      _totalAnswered++;
      if (isCorrect) {
        _correctCount++;
      }
    });
  }

  void _nextQuestion() {
    final state = ref.read(flashcardNotifierProvider);
    final notifier = ref.read(flashcardNotifierProvider.notifier);

    if (state.currentIndex < state.flashcards.length - 1) {
      // Move to next question
      notifier.nextCard();
      setState(() {
        _answerController.clear();
        _hasSubmitted = false;
        _isCorrect = false;
      });
    } else {
      // Quiz finished - show results
      _showResults();
    }
  }

  void _showResults() {
    final percentage = (_correctCount / _totalAnswered * 100).round();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          '🎉 Quiz Complete!',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              percentage >= 70 ? Icons.emoji_events : Icons.sentiment_neutral,
              size: 64,
              color: percentage >= 70 ? Colors.amber : Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Your Score',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '$_correctCount / $_totalAnswered',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '$percentage%',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: percentage >= 70 ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              percentage >= 90
                  ? 'Excellent! 🌟'
                  : percentage >= 70
                      ? 'Good job! 👍'
                      : percentage >= 50
                          ? 'Keep practicing! 💪'
                          : 'Try again! 📚',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to study screen
            },
            child: const Text('Back to Study'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // Restart quiz
              ref.read(flashcardNotifierProvider.notifier).loadFlashcards();
              setState(() {
                _correctCount = 0;
                _totalAnswered = 0;
                _answerController.clear();
                _hasSubmitted = false;
              });
            },
            child: const Text('Restart Quiz'),
          ),
        ],
      ),
    );
  }

  String _normalizeAnswer(String answer) {
    // Remove extra spaces, punctuation, and normalize
    return answer
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
