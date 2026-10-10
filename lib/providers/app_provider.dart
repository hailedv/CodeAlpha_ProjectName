import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import '../models/category.dart';
import '../models/study_session.dart';
import '../services/storage_service.dart';

class AppProvider with ChangeNotifier {
  final StorageService _storage = StorageService();

  List<Flashcard> _flashcards = [];
  List<Category> _categories = [];
  List<StudySession> _studySessions = [];
  bool _isDarkMode = false;
  int _studyStreak = 0;
  bool _isLoading = true;

  // Getters
  List<Flashcard> get flashcards => _flashcards;
  List<Category> get categories => _categories;
  List<StudySession> get studySessions => _studySessions;
  bool get isDarkMode => _isDarkMode;
  int get studyStreak => _studyStreak;
  bool get isLoading => _isLoading;

  // Statistics
  int get totalCards => _flashcards.length;
  int get totalSessions => _studySessions.length;
  int get favoriteCards => _flashcards.where((c) => c.isFavorite).length;
  
  double get overallMastery {
    if (_flashcards.isEmpty) return 0.0;
    final total = _flashcards.fold<double>(
      0.0,
      (sum, card) => sum + card.masteryPercentage,
    );
    return total / _flashcards.length;
  }

  // Initialize
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    _flashcards = await _storage.loadFlashcards();
    _categories = await _storage.loadCategories();
    _studySessions = await _storage.loadStudySessions();
    _isDarkMode = await _storage.loadThemeMode();
    _studyStreak = await _storage.getStudyStreak();

    _isLoading = false;
    notifyListeners();
  }

  // Flashcard operations
  Future<void> addFlashcard(Flashcard flashcard) async {
    _flashcards.add(flashcard);
    await _storage.saveFlashcards(_flashcards);
    notifyListeners();
  }

  Future<void> updateFlashcard(String id, Flashcard updatedCard) async {
    final index = _flashcards.indexWhere((c) => c.id == id);
    if (index != -1) {
      _flashcards[index] = updatedCard;
      await _storage.saveFlashcards(_flashcards);
      notifyListeners();
    }
  }

  Future<void> deleteFlashcard(String id) async {
    _flashcards.removeWhere((c) => c.id == id);
    await _storage.saveFlashcards(_flashcards);
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    final index = _flashcards.indexWhere((c) => c.id == id);
    if (index != -1) {
      _flashcards[index] = _flashcards[index].copyWith(
        isFavorite: !_flashcards[index].isFavorite,
      );
      await _storage.saveFlashcards(_flashcards);
      notifyListeners();
    }
  }

  Future<void> recordReview(String id, bool correct) async {
    final index = _flashcards.indexWhere((c) => c.id == id);
    if (index != -1) {
      final card = _flashcards[index];
      _flashcards[index] = card.copyWith(
        reviewCount: card.reviewCount + 1,
        correctCount: correct ? card.correctCount + 1 : card.correctCount,
        lastReviewedAt: DateTime.now(),
      );
      await _storage.saveFlashcards(_flashcards);
      notifyListeners();
    }
  }

  // Category operations
  Future<void> addCategory(Category category) async {
    _categories.add(category);
    await _storage.saveCategories(_categories);
    notifyListeners();
  }

  Future<void> updateCategory(String id, Category updatedCategory) async {
    final index = _categories.indexWhere((c) => c.id == id);
    if (index != -1) {
      _categories[index] = updatedCategory;
      await _storage.saveCategories(_categories);
      notifyListeners();
    }
  }

  Future<void> deleteCategory(String id) async {
    _categories.removeWhere((c) => c.id == id);
    // Update flashcards in deleted category to default
    for (int i = 0; i < _flashcards.length; i++) {
      if (_flashcards[i].categoryId == id) {
        _flashcards[i] = _flashcards[i].copyWith(categoryId: 'default');
      }
    }
    await _storage.saveCategories(_categories);
    await _storage.saveFlashcards(_flashcards);
    notifyListeners();
  }

  // Study session operations
  Future<void> addStudySession(StudySession session) async {
    _studySessions.add(session);
    await _storage.saveStudySessions(_studySessions);
    await _storage.updateStudyStreak();
    _studyStreak = await _storage.getStudyStreak();
    notifyListeners();
  }

  // Theme operations
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _storage.saveThemeMode(_isDarkMode);
    notifyListeners();
  }

  // Filter operations
  List<Flashcard> getFlashcardsByCategory(String categoryId) {
    return _flashcards.where((c) => c.categoryId == categoryId).toList();
  }

  List<Flashcard> getFavoriteFlashcards() {
    return _flashcards.where((c) => c.isFavorite).toList();
  }

  List<Flashcard> searchFlashcards(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _flashcards.where((card) {
      return card.question.toLowerCase().contains(lowercaseQuery) ||
          card.answer.toLowerCase().contains(lowercaseQuery) ||
          card.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // Export data
  Future<String?> exportData() async {
    try {
      final filePath = await _storage.exportData();
      return filePath;
    } catch (e) {
      return null;
    }
  }
}
