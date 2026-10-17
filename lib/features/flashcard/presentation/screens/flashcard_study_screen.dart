import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/category_entity.dart';
import '../providers/flashcard_providers.dart';
import '../providers/flashcard_state.dart';
import '../widgets/flip_card_widget.dart';
import 'flashcard_form_screen.dart';

/// Main Flashcard Study Screen - Clean Architecture UI
class FlashcardStudyScreen extends ConsumerStatefulWidget {
  const FlashcardStudyScreen({super.key});

  @override
  ConsumerState<FlashcardStudyScreen> createState() => _FlashcardStudyScreenState();
}

class _FlashcardStudyScreenState extends ConsumerState<FlashcardStudyScreen> {
  String? _selectedCategoryFilter;
  bool _isFlipped = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(flashcardNotifierProvider);
    final notifier = ref.read(flashcardNotifierProvider.notifier);

    // Reset flip state when card changes
    ref.listen(flashcardNotifierProvider, (previous, next) {
      if (previous?.currentIndex != next.currentIndex) {
        setState(() => _isFlipped = false);
      }
    });

    // Filter flashcards by category
    final flashcards = _selectedCategoryFilter == null
        ? state.flashcards
        : state.flashcards
            .where((card) => card.categoryId == _selectedCategoryFilter)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard Quiz Pro'),
        actions: [
          // Category Filter
          PopupMenuButton<String>(
            icon: Icon(
              _selectedCategoryFilter == null
                  ? Icons.filter_list
                  : Icons.filter_alt,
            ),
            tooltip: 'Filter by Category',
            onSelected: (value) {
              setState(() {
                _selectedCategoryFilter = value == 'all' ? null : value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Row(
                  children: [
                    Icon(Icons.all_inclusive),
                    SizedBox(width: 12),
                    Text('All Categories'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              ...Categories.all.map((category) {
                return PopupMenuItem(
                  value: category.id,
                  child: Row(
                    children: [
                      Icon(category.icon, color: category.color),
                      const SizedBox(width: 12),
                      Text(category.name),
                    ],
                  ),
                );
              }),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddCard(context),
            tooltip: 'Add Flashcard',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => notifier.loadFlashcards(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _buildBody(context, state.copyWith(flashcards: flashcards), notifier),
      bottomNavigationBar: flashcards.isNotEmpty 
          ? _buildNavigationBar(context, state.copyWith(flashcards: flashcards), notifier)
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

    final category = Categories.getById(state.currentFlashcard!.categoryId);

    return Column(
      children: [
        // Category Badge
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Chip(
            avatar: Icon(category.icon, color: category.color, size: 18),
            label: Text(
              category.name,
              style: TextStyle(color: category.color, fontWeight: FontWeight.bold),
            ),
            backgroundColor: category.color.withOpacity(0.1),
            side: BorderSide(color: category.color, width: 1.5),
          ),
        ),
        // Progress indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: (state.currentIndex + 1) / state.flashcards.length,
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Card ${state.currentIndex + 1} of ${state.flashcards.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        // Flashcard
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FlipCardWidget(
              flashcard: state.currentFlashcard!,
              isFlipped: _isFlipped,
              onTap: () {
                setState(() => _isFlipped = !_isFlipped);
              },
            ),
          ),
        ),
      ],
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
      padding: const EdgeInsets.all(16),
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
          IconButton.filled(
            onPressed: state.currentIndex > 0 ? () => notifier.previousCard() : null,
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Previous',
          ),
          IconButton.filled(
            onPressed: state.currentFlashcard != null
                ? () => _navigateToEditCard(context, state.currentFlashcard!)
                : null,
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
          ),
          IconButton.filled(
            onPressed: state.currentFlashcard != null
                ? () => _confirmDelete(context, notifier, state.currentFlashcard!.id)
                : null,
            icon: const Icon(Icons.delete),
            tooltip: 'Delete',
            style: IconButton.styleFrom(
              backgroundColor: Colors.red.shade400,
            ),
          ),
          IconButton.filled(
            onPressed: state.currentIndex < state.flashcards.length - 1
                ? () => notifier.nextCard()
                : null,
            icon: const Icon(Icons.arrow_forward),
            tooltip: 'Next',
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
              notifier.deleteFlashcard(id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
