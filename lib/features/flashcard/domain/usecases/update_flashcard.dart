import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/flashcard_entity.dart';
import '../repositories/flashcard_repository.dart';

/// Use Case: Update Flashcard
class UpdateFlashcard extends UseCase<Unit, FlashcardEntity> {
  final FlashcardRepository repository;

  UpdateFlashcard(this.repository);

  @override
  Future<Either<Failure, Unit>> call(FlashcardEntity flashcard) async {
    // Validation
    if (flashcard.question.trim().isEmpty) {
      return Left(ValidationFailure('Question cannot be empty'));
    }
    
    if (flashcard.answer.trim().isEmpty) {
      return Left(ValidationFailure('Answer cannot be empty'));
    }
    
    return await repository.updateFlashcard(flashcard);
  }
}
