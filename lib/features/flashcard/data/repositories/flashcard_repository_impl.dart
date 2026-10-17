import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/flashcard_entity.dart';
import '../../domain/repositories/flashcard_repository.dart';
import '../datasources/flashcard_local_datasource.dart';
import '../models/flashcard_model.dart';

/// Repository Implementation - Concrete implementation of abstract repository
class FlashcardRepositoryImpl implements FlashcardRepository {
  final FlashcardLocalDataSource localDataSource;

  FlashcardRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<FlashcardEntity>>> getAllFlashcards() async {
    try {
      final flashcards = await localDataSource.getAllFlashcards();
      return Right(flashcards.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure('Failed to get flashcards: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<FlashcardEntity>>> getFlashcardsByCategory(
    String categoryId,
  ) async {
    try {
      final flashcards = await localDataSource.getAllFlashcards();
      final filtered = flashcards
          .where((card) => card.categoryId == categoryId)
          .map((model) => model.toEntity())
          .toList();
      return Right(filtered);
    } catch (e) {
      return Left(CacheFailure('Failed to get flashcards: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, FlashcardEntity>> getFlashcardById(String id) async {
    try {
      final flashcard = await localDataSource.getFlashcardById(id);
      if (flashcard == null) {
        return Left(CacheFailure('Flashcard not found'));
      }
      return Right(flashcard.toEntity());
    } catch (e) {
      return Left(CacheFailure('Failed to get flashcard: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> addFlashcard(FlashcardEntity flashcard) async {
    try {
      final model = FlashcardModel.fromEntity(flashcard);
      await localDataSource.addFlashcard(model);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Failed to add flashcard: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateFlashcard(
    FlashcardEntity flashcard,
  ) async {
    try {
      final model = FlashcardModel.fromEntity(flashcard);
      await localDataSource.updateFlashcard(model);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Failed to update flashcard: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteFlashcard(String id) async {
    try {
      await localDataSource.deleteFlashcard(id);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Failed to delete flashcard: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> toggleFavorite(String id) async {
    try {
      final flashcard = await localDataSource.getFlashcardById(id);
      if (flashcard == null) {
        return Left(CacheFailure('Flashcard not found'));
      }
      
      final updated = FlashcardModel.fromEntity(
        flashcard.toEntity().copyWith(isFavorite: !flashcard.isFavorite),
      );
      
      await localDataSource.updateFlashcard(updated);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Failed to toggle favorite: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> recordReview(
    String id,
    bool isCorrect,
  ) async {
    try {
      final flashcard = await localDataSource.getFlashcardById(id);
      if (flashcard == null) {
        return Left(CacheFailure('Flashcard not found'));
      }
      
      final updated = FlashcardModel.fromEntity(
        flashcard.toEntity().copyWith(
              reviewCount: flashcard.reviewCount + 1,
              correctCount:
                  flashcard.correctCount + (isCorrect ? 1 : 0),
              lastReviewedAt: DateTime.now(),
            ),
      );
      
      await localDataSource.updateFlashcard(updated);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Failed to record review: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<FlashcardEntity>>> getFavoriteFlashcards() async {
    try {
      final flashcards = await localDataSource.getAllFlashcards();
      final favorites = flashcards
          .where((card) => card.isFavorite)
          .map((model) => model.toEntity())
          .toList();
      return Right(favorites);
    } catch (e) {
      return Left(CacheFailure('Failed to get favorites: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<FlashcardEntity>>> searchFlashcards(
    String query,
  ) async {
    try {
      final flashcards = await localDataSource.getAllFlashcards();
      final filtered = flashcards
          .where(
            (card) =>
                card.question.toLowerCase().contains(query.toLowerCase()) ||
                card.answer.toLowerCase().contains(query.toLowerCase()),
          )
          .map((model) => model.toEntity())
          .toList();
      return Right(filtered);
    } catch (e) {
      return Left(CacheFailure('Failed to search flashcards: ${e.toString()}'));
    }
  }
}
