// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlashcardModel _$FlashcardModelFromJson(Map<String, dynamic> json) =>
    FlashcardModel(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      categoryId: json['categoryId'] as String? ?? 'default',
      isFavorite: json['isFavorite'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastReviewedAt: json['lastReviewedAt'] == null
          ? null
          : DateTime.parse(json['lastReviewedAt'] as String),
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      correctCount: (json['correctCount'] as num?)?.toInt() ?? 0,
      hint: json['hint'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isMultipleChoice: json['isMultipleChoice'] as bool? ?? false,
      choices:
          (json['choices'] as List<dynamic>?)?.map((e) => e as String).toList(),
      correctChoiceIndex: (json['correctChoiceIndex'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FlashcardModelToJson(FlashcardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answer': instance.answer,
      'categoryId': instance.categoryId,
      'isFavorite': instance.isFavorite,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastReviewedAt': instance.lastReviewedAt?.toIso8601String(),
      'reviewCount': instance.reviewCount,
      'correctCount': instance.correctCount,
      'hint': instance.hint,
      'tags': instance.tags,
      'isMultipleChoice': instance.isMultipleChoice,
      'choices': instance.choices,
      'correctChoiceIndex': instance.correctChoiceIndex,
    };
