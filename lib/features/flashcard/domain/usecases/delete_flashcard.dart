import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/flashcard_repository.dart';

/// Use Case: Delete Flashcard
class DeleteFlashcard extends UseCase<Unit, String> {
  final FlashcardRepository repository;

  DeleteFlashcard(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    if (id.trim().isEmpty) {
      return Left(ValidationFailure('Flashcard ID cannot be empty'));
    }
    
    return await repository.deleteFlashcard(id);
  }
}
