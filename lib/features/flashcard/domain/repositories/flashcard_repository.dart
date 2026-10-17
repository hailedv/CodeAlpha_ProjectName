import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/flashcard_entity.dart';

/// Abstract repository interface - Domain layer doesn't know about implementation
abstract class FlashcardRepository {
  /// Get all flashcards
  Future<Either<Failure, List<FlashcardEntity>>> getAllFlashcards();
  
  /// Get flashcards by category
  Future<Either<Failure, List<FlashcardEntity>>> getFlashcardsByCategory(
    String categoryId,
  );
  
  /// Get a single flashcard by ID
  Future<Either<Failure, FlashcardEntity>> getFlashcardById(String id);
  
  /// Add a new flashcard
  Future<Either<Failure, Unit>> addFlashcard(FlashcardEntity flashcard);
  
  /// Update an existing flashcard
  Future<Either<Failure, Unit>> updateFlashcard(FlashcardEntity flashcard);
  
  /// Delete a flashcard
  Future<Either<Failure, Unit>> deleteFlashcard(String id);
  
  /// Toggle favorite status
  Future<Either<Failure, Unit>> toggleFavorite(String id);
  
  /// Record a review
  Future<Either<Failure, Unit>> recordReview(String id, bool isCorrect);
  
  /// Get favorite flashcards
  Future<Either<Failure, List<FlashcardEntity>>> getFavoriteFlashcards();
  
  /// Search flashcards
  Future<Either<Failure, List<FlashcardEntity>>> searchFlashcards(
    String query,
  );
}
