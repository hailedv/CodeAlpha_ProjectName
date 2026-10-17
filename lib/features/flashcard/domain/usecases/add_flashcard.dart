import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/flashcard_entity.dart';
import '../repositories/flashcard_repository.dart';

/// Use Case: Add Flashcard
class AddFlashcard extends UseCase<Unit, FlashcardEntity> {
  final FlashcardRepository repository;

  AddFlashcard(this.repository);

  @override
  Future<Either<Failure, Unit>> call(FlashcardEntity flashcard) async {
    // Validation
    if (flashcard.question.trim().isEmpty) {
      return Left(ValidationFailure('Question cannot be empty'));
    }
    
    if (flashcard.answer.trim().isEmpty) {
      return Left(ValidationFailure('Answer cannot be empty'));
    }
    
    if (flashcard.isMultipleChoice) {
      if (flashcard.choices == null || flashcard.choices!.length < 2) {
        return Left(
          ValidationFailure('Multiple choice must have at least 2 choices'),
        );
      }
      
      if (flashcard.correctChoiceIndex == null) {
        return Left(ValidationFailure('Correct choice must be selected'));
      }
    }
    
    return await repository.addFlashcard(flashcard);
  }
}
