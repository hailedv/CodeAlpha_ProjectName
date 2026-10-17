import 'package:equatable/equatable.dart';

/// Core Flashcard Entity - Pure business logic, no dependencies
class FlashcardEntity extends Equatable {
  final String id;
  final String question;
  final String answer;
  final String categoryId;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime? lastReviewedAt;
  final int reviewCount;
  final int correctCount;
  final String? hint;
  final List<String> tags;
  
  // Multiple choice fields
  final bool isMultipleChoice;
  final List<String>? choices;
  final int? correctChoiceIndex;

  const FlashcardEntity({
    required this.id,
    required this.question,
    required this.answer,
    this.categoryId = 'default',
    this.isFavorite = false,
    required this.createdAt,
    this.lastReviewedAt,
    this.reviewCount = 0,
    this.correctCount = 0,
    this.hint,
    this.tags = const [],
    this.isMultipleChoice = false,
    this.choices,
    this.correctChoiceIndex,
  });

  /// Calculate mastery percentage
  double get masteryPercentage {
    if (reviewCount == 0) return 0.0;
    return (correctCount / reviewCount) * 100;
  }

  /// Copy with method for immutability
  FlashcardEntity copyWith({
    String? id,
    String? question,
    String? answer,
    String? categoryId,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? lastReviewedAt,
    int? reviewCount,
    int? correctCount,
    String? hint,
    List<String>? tags,
    bool? isMultipleChoice,
    List<String>? choices,
    int? correctChoiceIndex,
  }) {
    return FlashcardEntity(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      categoryId: categoryId ?? this.categoryId,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      reviewCount: reviewCount ?? this.reviewCount,
      correctCount: correctCount ?? this.correctCount,
      hint: hint ?? this.hint,
      tags: tags ?? this.tags,
      isMultipleChoice: isMultipleChoice ?? this.isMultipleChoice,
      choices: choices ?? this.choices,
      correctChoiceIndex: correctChoiceIndex ?? this.correctChoiceIndex,
    );
  }

  @override
  List<Object?> get props => [
        id,
        question,
        answer,
        categoryId,
        isFavorite,
        createdAt,
        lastReviewedAt,
        reviewCount,
        correctCount,
        hint,
        tags,
        isMultipleChoice,
        choices,
        correctChoiceIndex,
      ];
}
