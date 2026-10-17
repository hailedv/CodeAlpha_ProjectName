import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flashcard_model.dart';

/// Abstract interface for local data source
abstract class FlashcardLocalDataSource {
  Future<List<FlashcardModel>> getAllFlashcards();
  Future<void> cacheFlashcards(List<FlashcardModel> flashcards);
  Future<FlashcardModel?> getFlashcardById(String id);
  Future<void> addFlashcard(FlashcardModel flashcard);
  Future<void> updateFlashcard(FlashcardModel flashcard);
  Future<void> deleteFlashcard(String id);
}

/// Implementation using SharedPreferences
class FlashcardLocalDataSourceImpl implements FlashcardLocalDataSource {
  static const String _flashcardsKey = 'CACHED_FLASHCARDS';
  final SharedPreferences sharedPreferences;

  FlashcardLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<FlashcardModel>> getAllFlashcards() async {
    final jsonString = sharedPreferences.getString(_flashcardsKey);
    
    if (jsonString == null) {
      return _getDefaultFlashcards();
    }
    
    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => FlashcardModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to parse flashcards');
    }
  }

  @override
  Future<void> cacheFlashcards(List<FlashcardModel> flashcards) async {
    final jsonString = json.encode(
      flashcards.map((card) => card.toJson()).toList(),
    );
    await sharedPreferences.setString(_flashcardsKey, jsonString);
  }

  @override
  Future<FlashcardModel?> getFlashcardById(String id) async {
    final flashcards = await getAllFlashcards();
    try {
      return flashcards.firstWhere((card) => card.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addFlashcard(FlashcardModel flashcard) async {
    final flashcards = await getAllFlashcards();
    flashcards.add(flashcard);
    await cacheFlashcards(flashcards);
  }

  @override
  Future<void> updateFlashcard(FlashcardModel flashcard) async {
    final flashcards = await getAllFlashcards();
    final index = flashcards.indexWhere((card) => card.id == flashcard.id);
    
    if (index != -1) {
      flashcards[index] = flashcard;
      await cacheFlashcards(flashcards);
    } else {
      throw Exception('Flashcard not found');
    }
  }

  @override
  Future<void> deleteFlashcard(String id) async {
    final flashcards = await getAllFlashcards();
    flashcards.removeWhere((card) => card.id == id);
    await cacheFlashcards(flashcards);
  }

  /// Get default flashcards on first launch
  List<FlashcardModel> _getDefaultFlashcards() {
    return [
      FlashcardModel(
        id: '1',
        question: 'What is Flutter?',
        answer:
            'Flutter is Google\'s UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.',
        categoryId: 'flutter',
        createdAt: DateTime.now(),
        isMultipleChoice: true,
        choices: [
          'A programming language',
          'A UI framework',
          'A database',
          'An operating system',
        ],
        correctChoiceIndex: 1,
        tags: ['flutter', 'basics'],
      ),
      FlashcardModel(
        id: '2',
        question: 'What is Clean Architecture?',
        answer:
            'Clean Architecture is a software design philosophy that separates concerns into layers, making the codebase independent of frameworks, UI, and databases.',
        categoryId: 'architecture',
        createdAt: DateTime.now(),
        tags: ['architecture', 'design'],
      ),
    ];
  }
}
