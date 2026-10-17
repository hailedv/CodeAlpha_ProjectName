import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/flashcard_entity.dart';
import '../../domain/repositories/flashcard_repository.dart';
import '../../domain/usecases/add_flashcard.dart';
import '../../domain/usecases/delete_flashcard.dart';
import '../../domain/usecases/get_all_flashcards.dart';
import '../../domain/usecases/update_flashcard.dart';
import '../../../../core/usecases/usecase.dart';
import 'flashcard_state.dart';

/// Flashcard State Notifier - Handles all business logic
class FlashcardNotifier extends StateNotifier<FlashcardState> {
  final GetAllFlashcards getAllFlashcards;
  final AddFlashcard addFlashcard;
  final UpdateFlashcard updateFlashcard;
  final DeleteFlashcard deleteFlashcard;
  final FlashcardRepository repository;

  FlashcardNotifier({
    required this.getAllFlashcards,
    required this.addFlashcard,
    required this.updateFlashcard,
    required this.deleteFlashcard,
    required this.repository,
  }) : super(const FlashcardState()) {
    loadFlashcards();
  }

  /// Load all flashcards
  Future<void> loadFlashcards() async {
    state = state.copyWith(
      isLoading: true,
      status: FlashcardStateStatus.loading,
    );

    final result = await getAllFlashcards(NoParams());

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          status: FlashcardStateStatus.error,
        );
      },
      (flashcards) {
        state = state.copyWith(
          flashcards: flashcards,
          isLoading: false,
          currentIndex: 0,
          isFlipped: false,
          status: FlashcardStateStatus.loaded,
        );
      },
    );
  }

  /// Flip current card
  void flipCard() {
    state = state.copyWith(isFlipped: !state.isFlipped);
  }

  /// Go to next card
  void nextCard() {
    if (state.canGoNext) {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        isFlipped: false,
      );
    }
  }

  /// Go to previous card
  void previousCard() {
    if (state.canGoPrevious) {
      state = state.copyWith(
        currentIndex: state.currentIndex - 1,
        isFlipped: false,
      );
    }
  }

  /// Add new flashcard
  Future<void> addNewFlashcard(FlashcardEntity flashcard) async {
    state = state.copyWith(
      isLoading: true,
      status: FlashcardStateStatus.loading,
    );

    final result = await addFlashcard(flashcard);

    await result.fold(
      (failure) async {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          status: FlashcardStateStatus.error,
        );
      },
      (_) async {
        await loadFlashcards();
        state = state.copyWith(
          status: FlashcardStateStatus.success,
          errorMessage: 'Flashcard added successfully',
        );
      },
    );
  }

  /// Update existing flashcard
  Future<void> updateExistingFlashcard(FlashcardEntity flashcard) async {
    state = state.copyWith(
      isLoading: true,
      status: FlashcardStateStatus.loading,
    );

    final result = await updateFlashcard(flashcard);

    await result.fold(
      (failure) async {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          status: FlashcardStateStatus.error,
        );
      },
      (_) async {
        await loadFlashcards();
        state = state.copyWith(
          status: FlashcardStateStatus.success,
          errorMessage: 'Flashcard updated successfully',
        );
      },
    );
  }

  /// Delete flashcard
  Future<void> deleteFlashcardById(String id) async {
    state = state.copyWith(
      isLoading: true,
      status: FlashcardStateStatus.loading,
    );

    final result = await deleteFlashcard(id);

    await result.fold(
      (failure) async {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          status: FlashcardStateStatus.error,
        );
      },
      (_) async {
        await loadFlashcards();
        state = state.copyWith(
          status: FlashcardStateStatus.success,
          errorMessage: 'Flashcard deleted successfully',
        );
      },
    );
  }

  /// Toggle favorite
  Future<void> toggleFavorite(String id) async {
    final result = await repository.toggleFavorite(id);
    result.fold(
      (failure) {
        state = state.copyWith(
          errorMessage: failure.message,
          status: FlashcardStateStatus.error,
        );
      },
      (_) {
        loadFlashcards();
      },
    );
  }

  /// Record review
  Future<void> recordReview(String id, bool isCorrect) async {
    final result = await repository.recordReview(id, isCorrect);
    result.fold(
      (failure) {
        state = state.copyWith(
          errorMessage: failure.message,
          status: FlashcardStateStatus.error,
        );
      },
      (_) {
        loadFlashcards();
      },
    );
  }

  /// Search flashcards
  Future<void> searchFlashcards(String query) async {
    if (query.trim().isEmpty) {
      await loadFlashcards();
      return;
    }

    state = state.copyWith(
      isLoading: true,
      status: FlashcardStateStatus.loading,
    );

    final result = await repository.searchFlashcards(query);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          status: FlashcardStateStatus.error,
        );
      },
      (flashcards) {
        state = state.copyWith(
          flashcards: flashcards,
          isLoading: false,
          currentIndex: 0,
          isFlipped: false,
          status: FlashcardStateStatus.loaded,
        );
      },
    );
  }

  /// Clear error
  void clearError() {
    state = state.clearError();
  }
}
