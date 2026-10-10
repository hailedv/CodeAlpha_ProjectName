import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../models/flashcard.dart';
import '../models/category.dart';
import '../models/study_session.dart';
import '../theme/app_theme.dart';
import 'package:flutter/material.dart';

class StorageService {
  static const String _flashcardsKey = 'flashcards';
  static const String _categoriesKey = 'categories';
  static const String _studySessionsKey = 'studySessions';
  static const String _themeKey = 'isDarkMode';
  static const String _studyStreakKey = 'studyStreak';
  static const String _lastStudyDateKey = 'lastStudyDate';

  // === Flashcards ===
  Future<void> saveFlashcards(List<Flashcard> flashcards) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = flashcards.map((card) => card.toJson()).toList();
    await prefs.setString(_flashcardsKey, jsonEncode(jsonList));
  }

  Future<List<Flashcard>> loadFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_flashcardsKey);
    
    if (jsonString == null || jsonString.isEmpty) {
      return _getDefaultFlashcards();
    }

    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => Flashcard.fromJson(json)).toList();
    } catch (e) {
      return _getDefaultFlashcards();
    }
  }

  // === Categories ===
  Future<void> saveCategories(List<Category> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = categories.map((cat) => cat.toJson()).toList();
    await prefs.setString(_categoriesKey, jsonEncode(jsonList));
  }

  Future<List<Category>> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_categoriesKey);
    
    if (jsonString == null || jsonString.isEmpty) {
      return _getDefaultCategories();
    }

    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      return _getDefaultCategories();
    }
  }

  // === Study Sessions ===
  Future<void> saveStudySessions(List<StudySession> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = sessions.map((session) => session.toJson()).toList();
    await prefs.setString(_studySessionsKey, jsonEncode(jsonList));
  }

  Future<List<StudySession>> loadStudySessions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_studySessionsKey);
    
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => StudySession.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // === Theme ===
  Future<void> saveThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  Future<bool> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  // === Study Streak ===
  Future<void> updateStudyStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDateString = prefs.getString(_lastStudyDateKey);
    final currentStreak = prefs.getInt(_studyStreakKey) ?? 0;
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month}-${today.day}';

    if (lastDateString == null) {
      await prefs.setInt(_studyStreakKey, 1);
      await prefs.setString(_lastStudyDateKey, todayString);
    } else {
      final lastDate = DateTime.parse(lastDateString);
      final difference = today.difference(lastDate).inDays;

      if (difference == 0) {
        // Already studied today
        return;
      } else if (difference == 1) {
        // Consecutive day
        await prefs.setInt(_studyStreakKey, currentStreak + 1);
        await prefs.setString(_lastStudyDateKey, todayString);
      } else {
        // Streak broken
        await prefs.setInt(_studyStreakKey, 1);
        await prefs.setString(_lastStudyDateKey, todayString);
      }
    }
  }

  Future<int> getStudyStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_studyStreakKey) ?? 0;
  }

  // === Import/Export ===
  Future<String> exportData() async {
    final flashcards = await loadFlashcards();
    final categories = await loadCategories();
    final sessions = await loadStudySessions();

    final data = {
      'flashcards': flashcards.map((f) => f.toJson()).toList(),
      'categories': categories.map((c) => c.toJson()).toList(),
      'sessions': sessions.map((s) => s.toJson()).toList(),
      'exportDate': DateTime.now().toIso8601String(),
    };

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/flashcard_backup_${DateTime.now().millisecondsSinceEpoch}.json');
    await file.writeAsString(jsonEncode(data));
    
    return file.path;
  }

  Future<bool> importData(String filePath) async {
    try {
      final file = File(filePath);
      final jsonString = await file.readAsString();
      final data = jsonDecode(jsonString);

      if (data['flashcards'] != null) {
        final flashcards = (data['flashcards'] as List)
            .map((json) => Flashcard.fromJson(json))
            .toList();
        await saveFlashcards(flashcards);
      }

      if (data['categories'] != null) {
        final categories = (data['categories'] as List)
            .map((json) => Category.fromJson(json))
            .toList();
        await saveCategories(categories);
      }

      if (data['sessions'] != null) {
        final sessions = (data['sessions'] as List)
            .map((json) => StudySession.fromJson(json))
            .toList();
        await saveStudySessions(sessions);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // === Default Data ===
  List<Flashcard> _getDefaultFlashcards() {
    return [
      // Multiple Choice Questions
      Flashcard(
        id: '1',
        question: 'What is Flutter?',
        answer: 'An open-source UI framework by Google',
        categoryId: 'flutter',
        hint: 'Think about mobile development',
        tags: ['flutter', 'basics'],
        isMultipleChoice: true,
        choices: [
          'An open-source UI framework by Google',
          'A programming language',
          'A database system',
          'An operating system',
        ],
        correctChoiceIndex: 0,
      ),
      Flashcard(
        id: '2',
        question: 'Which programming language is used in Flutter?',
        answer: 'Dart',
        categoryId: 'flutter',
        hint: 'Google developed this language',
        tags: ['flutter', 'language'],
        isMultipleChoice: true,
        choices: [
          'Java',
          'Kotlin',
          'Dart',
          'Swift',
        ],
        correctChoiceIndex: 2,
      ),
      Flashcard(
        id: '3',
        question: 'What does API stand for?',
        answer: 'Application Programming Interface',
        categoryId: 'programming',
        hint: 'Interface between systems',
        tags: ['programming', 'basics'],
        isMultipleChoice: true,
        choices: [
          'Advanced Programming Integration',
          'Application Programming Interface',
          'Automated Process Integration',
          'Application Process Interface',
        ],
        correctChoiceIndex: 1,
      ),
      Flashcard(
        id: '4',
        question: 'Which planet is known as the Red Planet?',
        answer: 'Mars',
        categoryId: 'science',
        hint: 'Fourth planet from the Sun',
        tags: ['science', 'astronomy'],
        isMultipleChoice: true,
        choices: [
          'Venus',
          'Jupiter',
          'Mars',
          'Saturn',
        ],
        correctChoiceIndex: 2,
      ),
      Flashcard(
        id: '5',
        question: 'What is the capital of France?',
        answer: 'Paris',
        categoryId: 'general',
        hint: 'City of lights',
        tags: ['geography', 'capitals'],
        isMultipleChoice: true,
        choices: [
          'London',
          'Berlin',
          'Madrid',
          'Paris',
        ],
        correctChoiceIndex: 3,
      ),
      
      // Traditional Q&A Questions
      Flashcard(
        id: '6',
        question: 'What does HTML stand for?',
        answer: 'HyperText Markup Language',
        categoryId: 'programming',
        hint: 'Web page structure',
        tags: ['web', 'basics'],
        isMultipleChoice: false,
      ),
      Flashcard(
        id: '7',
        question: 'Who painted the Mona Lisa?',
        answer: 'Leonardo da Vinci',
        categoryId: 'general',
        hint: 'Renaissance artist',
        tags: ['art', 'history'],
        isMultipleChoice: false,
      ),
      Flashcard(
        id: '8',
        question: 'What is the largest ocean on Earth?',
        answer: 'Pacific Ocean',
        categoryId: 'science',
        hint: 'Covers more area than all land',
        tags: ['geography', 'oceans'],
        isMultipleChoice: false,
      ),
    ];
  }

  List<Category> _getDefaultCategories() {
    return [
      Category(
        id: 'default',
        name: 'General',
        description: 'General flashcards',
        icon: Icons.lightbulb,
        color: AppTheme.primaryGold,
      ),
      Category(
        id: 'flutter',
        name: 'Flutter',
        description: 'Flutter framework concepts',
        icon: Icons.flutter_dash,
        color: AppTheme.darkGold,
      ),
      Category(
        id: 'programming',
        name: 'Programming',
        description: 'Programming concepts and languages',
        icon: Icons.code,
        color: AppTheme.amber,
      ),
      Category(
        id: 'science',
        name: 'Science',
        description: 'Scientific concepts and facts',
        icon: Icons.science,
        color: AppTheme.lightGold,
      ),
      Category(
        id: 'language',
        name: 'Languages',
        description: 'Language learning flashcards',
        icon: Icons.translate,
        color: AppTheme.primaryGold,
      ),
    ];
  }
}
