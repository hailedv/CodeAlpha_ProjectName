import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flashcard_model.dart';
import 'sample_flashcards.dart';

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
  static const String _firstLaunchKey = 'FIRST_LAUNCH';
  final SharedPreferences sharedPreferences;

  FlashcardLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<FlashcardModel>> getAllFlashcards() async {
    // Check if first launch
    final isFirstLaunch = sharedPreferences.getBool(_firstLaunchKey) ?? true;
    
    if (isFirstLaunch) {
      // Load sample flashcards on first launch
      final sampleCards = SampleFlashcards.all
          .map((entity) => FlashcardModel(
                id: entity.id,
                question: entity.question,
                answer: entity.answer,
                categoryId: entity.categoryId,
                isFavorite: entity.isFavorite,
                createdAt: entity.createdAt,
                lastReviewedAt: entity.lastReviewedAt,
                reviewCount: entity.reviewCount,
                correctCount: entity.correctCount,
                hint: entity.hint,
                tags: entity.tags,
                isMultipleChoice: entity.isMultipleChoice,
                choices: entity.choices,
                correctChoiceIndex: entity.correctChoiceIndex,
              ))
          .toList();
      
      await cacheFlashcards(sampleCards);
      await sharedPreferences.setBool(_firstLaunchKey, false);
      return sampleCards;
    }
    
    final jsonString = sharedPreferences.getString(_flashcardsKey);
    
    if (jsonString == null) {
      return [];
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
}
