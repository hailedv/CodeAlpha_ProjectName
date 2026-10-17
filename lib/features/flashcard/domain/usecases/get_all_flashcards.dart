import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/flashcard_entity.dart';
import '../repositories/flashcard_repository.dart';

/// Use Case: Get All Flashcards
class GetAllFlashcards extends UseCase<List<FlashcardEntity>, NoParams> {
  final FlashcardRepository repository;

  GetAllFlashcards(this.repository);

  @override
  Future<Either<Failure, List<FlashcardEntity>>> call(NoParams params) async {
    return await repository.getAllFlashcards();
  }
}
