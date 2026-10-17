import 'package:equatable/equatable.dart';
import '../../domain/entities/flashcard_entity.dart';

/// Flashcard State - Immutable state class
class FlashcardState extends Equatable {
  final List<FlashcardEntity> flashcards;
  final int currentIndex;
  final bool isFlipped;
  final bool isLoading;
  final String? errorMessage;
  final FlashcardStateStatus status;

  const FlashcardState({
    this.flashcards = const [],
    this.currentIndex = 0,
    this.isFlipped = false,
    this.isLoading = false,
    this.errorMessage,
    this.status = FlashcardStateStatus.initial,
  });

  /// Get current flashcard
  FlashcardEntity? get currentFlashcard {
    if (flashcards.isEmpty || currentIndex >= flashcards.length) {
      return null;
    }
    return flashcards[currentIndex];
  }

  /// Check if can go to next card
  bool get canGoNext => currentIndex < flashcards.length - 1;

  /// Check if can go to previous card
  bool get canGoPrevious => currentIndex > 0;

  /// Copy with method for immutability
  FlashcardState copyWith({
    List<FlashcardEntity>? flashcards,
    int? currentIndex,
    bool? isFlipped,
    bool? isLoading,
    String? errorMessage,
    FlashcardStateStatus? status,
  }) {
    return FlashcardState(
      flashcards: flashcards ?? this.flashcards,
      currentIndex: currentIndex ?? this.currentIndex,
      isFlipped: isFlipped ?? this.isFlipped,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      status: status ?? this.status,
    );
  }

  /// Copy with cleared error
  FlashcardState clearError() {
    return copyWith(
      errorMessage: null,
      status: FlashcardStateStatus.loaded,
    );
  }

  @override
  List<Object?> get props => [
        flashcards,
        currentIndex,
        isFlipped,
        isLoading,
        errorMessage,
        status,
      ];
}

/// State status enum
enum FlashcardStateStatus {
  initial,
  loading,
  loaded,
  error,
  success,
}
