import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/flashcard_providers.dart';
import '../providers/flashcard_state.dart';
import 'flashcard_form_screen.dart';
import 'flashcard_quiz_mode_screen.dart';
import 'flashcard_exam_mode_screen.dart';

/// Main Flashcard Study Screen - Simple & Clean UI
class FlashcardStudyScreen extends ConsumerStatefulWidget {
  const FlashcardStudyScreen({super.key});

  @override
  ConsumerState<FlashcardStudyScreen> createState() => _FlashcardStudyScreenState();
}

class _FlashcardStudyScreenState extends ConsumerState<FlashcardStudyScreen> {
  bool _isFlipped = false;
  String? _selectedCategory;
  bool _showAnswerInput = false;
  final TextEditingController _userAnswerController = TextEditingController();
  bool _hasCheckedAnswer = false;
  bool _isUserAnswerCorrect = false;

  @override
  void initState() {
    super.initState();
    // Listen to text changes to enable/disable button
    _userAnswerController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _userAnswerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(flashcardNotifierProvider);
    final notifier = ref.read(flashcardNotifierProvider.notifier);

    // Reset flip state when card changes
    ref.listen(flashcardNotifierProvider, (previous, next) {
      if (previous?.currentIndex != next.currentIndex) {
        setState(() {
          _isFlipped = false;
          _showAnswerInput = false;
          _hasCheckedAnswer = false;
          _isUserAnswerCorrect = false;
          _userAnswerController.clear();
        });
      }
    });

    // Filter flashcards by category
    final flashcards = _selectedCategory == null
        ? state.flashcards
        : state.flashcards
            .where((card) => card.categoryId == _selectedCategory)
            .toList();

    final filteredState = state.copyWith(
      flashcards: flashcards,
      currentIndex: flashcards.isEmpty ? 0 : (state.currentIndex >= flashcards.length ? 0 : state.currentIndex),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard Quiz'),
        centerTitle: true,
        actions: [
          // Exam Mode Button (Answer all, then submit)
          IconButton(
            icon: const Icon(Icons.assignment),
            onPressed: () => _navigateToExamMode(context),
            tooltip: 'Exam Mode',
            iconSize: 28,
          ),
          // Quiz Mode Button (One by one)
          IconButton(
            icon: const Icon(Icons.quiz),
            onPressed: () => _navigateToQuizMode(context),
            tooltip: 'Quiz Mode',
            iconSize: 28,
          ),
          // Category Filter Button
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Choose Category',
            onSelected: (value) {
              setState(() {
                _selectedCategory = value == 'all' ? null : value;
                _isFlipped = false;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Row(
                  children: [
                    Icon(Icons.all_inclusive, color: Colors.grey),
                    SizedBox(width: 12),
                    Text('All Categories'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'mathematics',
                child: Row(
                  children: [
                    Icon(Icons.calculate, color: Colors.pink),
                    const SizedBox(width: 12),
                    Text('Mathematics (${state.flashcards.where((c) => c.categoryId == 'mathematics').length})'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'english',
                child: Row(
                  children: [
                    Icon(Icons.menu_book, color: Colors.blue),
                    const SizedBox(width: 12),
                    Text('English (${state.flashcards.where((c) => c.categoryId == 'english').length})'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'science',
                child: Row(
                  children: [
                    Icon(Icons.science, color: Colors.green),
                    const SizedBox(width: 12),
                    Text('Science (${state.flashcards.where((c) => c.categoryId == 'science').length})'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'general',
                child: Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.amber),
                    const SizedBox(width: 12),
                    Text('General (${state.flashcards.where((c) => c.categoryId == 'general').length})'),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () => _navigateToAddCard(context),
            tooltip: 'Add New Flashcard',
            iconSize: 32,
          ),
        ],
      ),
      body: _buildBody(context, filteredState, notifier),
      bottomNavigationBar: flashcards.isNotEmpty 
          ? _buildNavigationBar(context, filteredState, notifier)
          : null,
    );
  }

  Widget _buildBody(
    BuildContext context,
    FlashcardState state,
    dynamic notifier,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.flashcards.isEmpty) {
      return _buildEmptyState(context);
    }

    if (state.currentFlashcard == null) {
      return const Center(child: Text('No flashcard available'));
    }

    return Column(
      children: [
        // Category Badge (if filtered)
        if (_selectedCategory != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getCategoryIcon(_selectedCategory!),
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Showing: ${_getCategoryName(_selectedCategory!)}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCategory = null;
                      _isFlipped = false;
                    });
                  },
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        // Progress indicator
        Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Card ${state.currentIndex + 1} of ${state.flashcards.length}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        // Flashcard
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: _buildSimpleCard(context, state.currentFlashcard!),
          ),
        ),
        
        // Answer Input Section (Before showing answer)
        if (!_isFlipped && !_showAnswerInput)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Text(
                  'Try to answer first!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() => _showAnswerInput = true);
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('I want to answer'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() => _isFlipped = true);
                        },
                        icon: const Icon(Icons.visibility),
                        label: const Text('Show Answer'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        // User Answer Input Field
        if (!_isFlipped && _showAnswerInput && !_hasCheckedAnswer)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _userAnswerController,
                  decoration: InputDecoration(
                    labelText: 'Your Answer',
                    hintText: 'Type your answer here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    prefixIcon: const Icon(Icons.edit),
                  ),
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                  autofocus: true,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _showAnswerInput = false;
                            _userAnswerController.clear();
                          });
                        },
                        icon: const Icon(Icons.close),
                        label: const Text('Cancel'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _userAnswerController.text.trim().isNotEmpty
                            ? _checkUserAnswer
                            : null,
                        icon: const Icon(Icons.check),
                        label: const Text('Check Answer'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        // Answer Feedback (After checking)
        if (!_isFlipped && _hasCheckedAnswer)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  color: _isUserAnswerCorrect
                      ? Colors.green.shade50
                      : Colors.orange.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          _isUserAnswerCorrect
                              ? Icons.check_circle
                              : Icons.info,
                          size: 48,
                          color: _isUserAnswerCorrect
                              ? Colors.green
                              : Colors.orange,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _isUserAnswerCorrect
                              ? 'Correct! 🎉'
                              : 'Let\'s check the answer',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _isUserAnswerCorrect
                                    ? Colors.green.shade700
                                    : Colors.orange.shade700,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your answer: ${_userAnswerController.text}',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() => _isFlipped = true);
                  },
                  icon: const Icon(Icons.visibility),
                  label: const Text('Show Correct Answer'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),

        // Show Answer Button (When flipped = false and no input shown)
        if (_isFlipped)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _isFlipped = false;
                  _showAnswerInput = false;
                  _hasCheckedAnswer = false;
                  _userAnswerController.clear();
                });
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 48),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Hide Answer',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }

  /// Simple card without 3D flip animation - just show/hide
  Widget _buildSimpleCard(BuildContext context, flashcard) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Question Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: 36,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Question',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      flashcard.question,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Answer Section (only show when flipped)
              if (_isFlipped) ...[
                const SizedBox(height: 20),
                const Divider(thickness: 2),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 36,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Answer',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        flashcard.answer,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.green.shade900,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.style_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Flashcards Yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to create your first flashcard',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddCard(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Flashcard'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar(
    BuildContext context,
    FlashcardState state,
    dynamic notifier,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Previous Button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: state.currentIndex > 0 
                ? () {
                    notifier.previousCard();
                    setState(() => _isFlipped = false);
                  } 
                : null,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Previous'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Edit Button
          IconButton.filled(
            onPressed: state.currentFlashcard != null
                ? () => _navigateToEditCard(context, state.currentFlashcard!)
                : null,
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Flashcard',
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(width: 12),
          // Delete Button
          IconButton.filled(
            onPressed: state.currentFlashcard != null
                ? () => _confirmDelete(context, notifier, state.currentFlashcard!.id)
                : null,
            icon: const Icon(Icons.delete),
            tooltip: 'Delete Flashcard',
            style: IconButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              padding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(width: 12),
          // Next Button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: state.currentIndex < state.flashcards.length - 1
                ? () {
                    notifier.nextCard();
                    setState(() => _isFlipped = false);
                  }
                : null,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAddCard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FlashcardFormScreen(),
      ),
    );
  }

  void _navigateToQuizMode(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FlashcardQuizModeScreen(),
      ),
    );
  }

  void _navigateToExamMode(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FlashcardExamModeScreen(),
      ),
    );
  }

  void _navigateToEditCard(BuildContext context, flashcard) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashcardFormScreen(flashcard: flashcard),
      ),
    );
  }

  void _confirmDelete(BuildContext context, dynamic notifier, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Flashcard'),
        content: const Text('Are you sure you want to delete this flashcard?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              notifier.deleteFlashcardById(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Flashcard deleted successfully!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'mathematics':
        return Icons.calculate;
      case 'english':
        return Icons.menu_book;
      case 'science':
        return Icons.science;
      case 'general':
        return Icons.lightbulb;
      default:
        return Icons.category;
    }
  }

  String _getCategoryName(String categoryId) {
    switch (categoryId) {
      case 'mathematics':
        return 'Mathematics';
      case 'english':
        return 'English';
      case 'science':
        return 'Science';
      case 'general':
        return 'General Knowledge';
      default:
        return 'Other';
    }
  }
}


  void _checkUserAnswer() {
    final state = ref.read(flashcardNotifierProvider);
    final currentCard = state.currentFlashcard!;
    final userAnswer = _userAnswerController.text.trim().toLowerCase();
    final correctAnswer = currentCard.answer.toLowerCase();

    // Check if answer is correct (case-insensitive, partial match)
    final isCorrect = correctAnswer.contains(userAnswer) ||
        userAnswer.contains(correctAnswer) ||
        _normalizeAnswer(userAnswer) == _normalizeAnswer(correctAnswer);

    setState(() {
      _hasCheckedAnswer = true;
      _isUserAnswerCorrect = isCorrect;
    });
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
