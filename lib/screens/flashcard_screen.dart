import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/flashcard.dart';
import '../models/study_session.dart';
import '../widgets/flashcard_widget.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class FlashcardScreen extends StatefulWidget {
  final List<Flashcard> flashcards;

  const FlashcardScreen({super.key, required this.flashcards});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  int _currentIndex = 0;
  bool _showAnswer = false;
  late DateTime _sessionStartTime;
  int _correctCount = 0;
  List<bool> _results = [];
  int? _selectedChoiceIndex;

  @override
  void initState() {
    super.initState();
    _sessionStartTime = DateTime.now();
    _results = List.filled(widget.flashcards.length, false);
  }

  void _nextCard() {
    if (_currentIndex < widget.flashcards.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
        _selectedChoiceIndex = null;
      });
    } else {
      _completeSession();
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showAnswer = false;
        _selectedChoiceIndex = null;
      });
    }
  }

  void _toggleAnswer() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  void _onChoiceSelected(int index) {
    final currentCard = widget.flashcards[_currentIndex];
    final isCorrect = index == currentCard.correctChoiceIndex;
    
    setState(() {
      _selectedChoiceIndex = index;
      _showAnswer = true; // Show expanded answer
    });

    _markCorrect(isCorrect);
  }

  void _markCorrect(bool isCorrect) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final currentCard = widget.flashcards[_currentIndex];
    
    appProvider.recordReview(currentCard.id, isCorrect);
    
    if (isCorrect && !_results[_currentIndex]) {
      _correctCount++;
    } else if (!isCorrect && _results[_currentIndex]) {
      _correctCount--;
    }
    
    setState(() {
      _results[_currentIndex] = isCorrect;
    });

    // Auto advance immediately for multiple-choice
    if (currentCard.isMultipleChoice) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) _nextCard();
      });
    }
  }

  void _completeSession() {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final duration = DateTime.now().difference(_sessionStartTime);
    
    final session = StudySession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: _sessionStartTime,
      endTime: DateTime.now(),
      cardsStudied: widget.flashcards.length,
      correctAnswers: _correctCount,
      totalTime: duration.inSeconds,
    );

    appProvider.addStudySession(session);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.celebration, color: AppTheme.primaryGold),
            const SizedBox(width: 12),
            const Text('Session Complete!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.paleGold.withOpacity(0.3),
                    AppTheme.lightGold.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    '${(_correctCount / widget.flashcards.length * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = AppTheme.goldShimmerGradient.createShader(
                          const Rect.fromLTWH(0, 0, 200, 70),
                        ),
                    ),
                  ),
                  const Text('Accuracy', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildResultRow('Cards Studied', widget.flashcards.length.toString()),
            _buildResultRow('Correct', _correctCount.toString()),
            _buildResultRow('Incorrect', (widget.flashcards.length - _correctCount).toString()),
            _buildResultRow('Time', '${duration.inMinutes}m ${duration.inSeconds % 60}s'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Finish'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentIndex = 0;
                _showAnswer = false;
                _selectedChoiceIndex = null;
                _sessionStartTime = DateTime.now();
                _correctCount = 0;
                _results = List.filled(widget.flashcards.length, false);
              });
            },
            child: const Text('Study Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentCard = widget.flashcards[_currentIndex];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Card ${_currentIndex + 1} of ${widget.flashcards.length}'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(currentCard.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              appProvider.toggleFavorite(currentCard.id);
            },
          ),
        ],
      ),
      body: Container(
        decoration: isDark ? AppTheme.darkGoldGradientDecoration : AppTheme.goldGradientDecoration,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: (_currentIndex + 1) / widget.flashcards.length,
                  backgroundColor: isDark ? AppTheme.warmBrown : AppTheme.paleGold,
                  valueColor: AlwaysStoppedAnimation<Color>(isDark ? AppTheme.lightGold : AppTheme.primaryGold),
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(6),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        isDark ? AppTheme.lightGold : AppTheme.primaryGold,
                        isDark ? AppTheme.primaryGold : AppTheme.darkGold,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.emoji_events, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Score: $_correctCount/${_currentIndex > 0 ? _currentIndex : 1}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: FlashcardWidget(
                      flashcard: currentCard,
                      showAnswer: _showAnswer,
                      onChoiceSelected: currentCard.isMultipleChoice && !_showAnswer ? _onChoiceSelected : null,
                      selectedChoiceIndex: _selectedChoiceIndex,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (!currentCard.isMultipleChoice) ...[
                  if (!_showAnswer)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _toggleAnswer,
                        icon: const Icon(Icons.visibility),
                        label: const Text('Show Answer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  if (_showAnswer) ...[
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: () => _markCorrect(false),
                              icon: const Icon(Icons.close),
                              label: const Text('Incorrect'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400, foregroundColor: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: () => _markCorrect(true),
                              icon: const Icon(Icons.check),
                              label: const Text('Correct'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade400, foregroundColor: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _toggleAnswer,
                        icon: const Icon(Icons.visibility_off),
                        label: const Text('Hide Answer'),
                      ),
                    ),
                  ],
                ],
                if (currentCard.isMultipleChoice && _showAnswer) ...[
                  const SizedBox(height: 16),
                  // Result feedback with animation
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _selectedChoiceIndex == currentCard.correctChoiceIndex
                            ? [Colors.green.withOpacity(0.2), Colors.green.withOpacity(0.1)]
                            : [Colors.red.withOpacity(0.2), Colors.red.withOpacity(0.1)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _selectedChoiceIndex == currentCard.correctChoiceIndex 
                            ? Colors.green 
                            : Colors.red,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Result icon and text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _selectedChoiceIndex == currentCard.correctChoiceIndex 
                                  ? Icons.check_circle 
                                  : Icons.cancel,
                              color: _selectedChoiceIndex == currentCard.correctChoiceIndex 
                                  ? Colors.green 
                                  : Colors.red,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _selectedChoiceIndex == currentCard.correctChoiceIndex
                                  ? 'Correct! 🎉'
                                  : 'Incorrect!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _selectedChoiceIndex == currentCard.correctChoiceIndex
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        
                        // Expanded answer explanation
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark 
                                ? AppTheme.warmBrown.withOpacity(0.3)
                                : Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.lightbulb,
                                    color: isDark ? AppTheme.lightGold : AppTheme.primaryGold,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Explanation:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? AppTheme.lightGold : AppTheme.primaryGold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                currentCard.answer,
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: isDark ? Colors.white : AppTheme.deepBrown,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: _currentIndex > 0 ? _previousCard : null,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Previous'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: _nextCard,
                          icon: Icon(_currentIndex < widget.flashcards.length - 1 ? Icons.arrow_forward : Icons.check_circle),
                          label: Text(_currentIndex < widget.flashcards.length - 1 ? 'Next' : 'Finish'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
