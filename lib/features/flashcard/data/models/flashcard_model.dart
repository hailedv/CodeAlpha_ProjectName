import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/flashcard_entity.dart';

part 'flashcard_model.g.dart';

/// Data Transfer Object - Handles JSON serialization
@JsonSerializable()
class FlashcardModel extends FlashcardEntity {
  const FlashcardModel({
    required super.id,
    required super.question,
    required super.answer,
    super.categoryId,
    super.isFavorite,
    required super.createdAt,
    super.lastReviewedAt,
    super.reviewCount,
    super.correctCount,
    super.hint,
    super.tags,
    super.isMultipleChoice,
    super.choices,
    super.correctChoiceIndex,
  });

  /// From JSON factory
  factory FlashcardModel.fromJson(Map<String, dynamic> json) =>
      _$FlashcardModelFromJson(json);

  /// To JSON method
  Map<String, dynamic> toJson() => _$FlashcardModelToJson(this);

  /// From Entity
  factory FlashcardModel.fromEntity(FlashcardEntity entity) {
    return FlashcardModel(
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
    );
  }

  /// To Entity
  FlashcardEntity toEntity() {
    return FlashcardEntity(
      id: id,
      question: question,
      answer: answer,
      categoryId: categoryId,
      isFavorite: isFavorite,
      createdAt: createdAt,
      lastReviewedAt: lastReviewedAt,
      reviewCount: reviewCount,
      correctCount: correctCount,
      hint: hint,
      tags: tags,
      isMultipleChoice: isMultipleChoice,
      choices: choices,
      correctChoiceIndex: correctChoiceIndex,
    );
  }
}
