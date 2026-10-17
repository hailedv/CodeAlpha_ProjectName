import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/flashcard_local_datasource.dart';
import '../../data/repositories/flashcard_repository_impl.dart';
import '../../domain/repositories/flashcard_repository.dart';
import '../../domain/usecases/add_flashcard.dart';
import '../../domain/usecases/delete_flashcard.dart';
import '../../domain/usecases/get_all_flashcards.dart';
import '../../domain/usecases/update_flashcard.dart';
import '../../../../core/usecases/usecase.dart';
import 'flashcard_state.dart';
import 'flashcard_notifier.dart';

/// SharedPreferences provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden');
});

/// Local Data Source provider
final flashcardLocalDataSourceProvider = Provider<FlashcardLocalDataSource>(
  (ref) {
    final sharedPreferences = ref.watch(sharedPreferencesProvider);
    return FlashcardLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  },
);

/// Repository provider
final flashcardRepositoryProvider = Provider<FlashcardRepository>((ref) {
  final localDataSource = ref.watch(flashcardLocalDataSourceProvider);
  return FlashcardRepositoryImpl(localDataSource: localDataSource);
});

/// Use Cases providers
final getAllFlashcardsUseCaseProvider = Provider<GetAllFlashcards>((ref) {
  final repository = ref.watch(flashcardRepositoryProvider);
  return GetAllFlashcards(repository);
});

final addFlashcardUseCaseProvider = Provider<AddFlashcard>((ref) {
  final repository = ref.watch(flashcardRepositoryProvider);
  return AddFlashcard(repository);
});

final updateFlashcardUseCaseProvider = Provider<UpdateFlashcard>((ref) {
  final repository = ref.watch(flashcardRepositoryProvider);
  return UpdateFlashcard(repository);
});

final deleteFlashcardUseCaseProvider = Provider<DeleteFlashcard>((ref) {
  final repository = ref.watch(flashcardRepositoryProvider);
  return DeleteFlashcard(repository);
});

/// Main Flashcard State Notifier Provider
final flashcardNotifierProvider =
    StateNotifierProvider<FlashcardNotifier, FlashcardState>((ref) {
  return FlashcardNotifier(
    getAllFlashcards: ref.watch(getAllFlashcardsUseCaseProvider),
    addFlashcard: ref.watch(addFlashcardUseCaseProvider),
    updateFlashcard: ref.watch(updateFlashcardUseCaseProvider),
    deleteFlashcard: ref.watch(deleteFlashcardUseCaseProvider),
    repository: ref.watch(flashcardRepositoryProvider),
  );
});
