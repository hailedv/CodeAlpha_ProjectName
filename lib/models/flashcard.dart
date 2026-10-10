class Flashcard {
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
  final List<String>? choices;
  final int? correctChoiceIndex;
  final bool isMultipleChoice;

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    this.categoryId = 'default',
    this.isFavorite = false,
    DateTime? createdAt,
    this.lastReviewedAt,
    this.reviewCount = 0,
    this.correctCount = 0,
    this.hint,
    this.tags = const [],
    this.choices,
    this.correctChoiceIndex,
    this.isMultipleChoice = false,
  }) : createdAt = createdAt ?? DateTime.now();

  // Calculate mastery percentage
  double get masteryPercentage {
    if (reviewCount == 0) return 0.0;
    return (correctCount / reviewCount) * 100;
  }

  // Convert Flashcard to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'categoryId': categoryId,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
      'lastReviewedAt': lastReviewedAt?.toIso8601String(),
      'reviewCount': reviewCount,
      'correctCount': correctCount,
      'hint': hint,
      'tags': tags,
      'choices': choices,
      'correctChoiceIndex': correctChoiceIndex,
      'isMultipleChoice': isMultipleChoice,
    };
  }

  // Create Flashcard from JSON
  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      categoryId: json['categoryId'] ?? 'default',
      isFavorite: json['isFavorite'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      lastReviewedAt: json['lastReviewedAt'] != null
          ? DateTime.parse(json['lastReviewedAt'])
          : null,
      reviewCount: json['reviewCount'] ?? 0,
      correctCount: json['correctCount'] ?? 0,
      hint: json['hint'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      choices: json['choices'] != null ? List<String>.from(json['choices']) : null,
      correctChoiceIndex: json['correctChoiceIndex'],
      isMultipleChoice: json['isMultipleChoice'] ?? false,
    );
  }

  // Create a copy with modified fields
  Flashcard copyWith({
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
    List<String>? choices,
    int? correctChoiceIndex,
    bool? isMultipleChoice,
  }) {
    return Flashcard(
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
      choices: choices ?? this.choices,
      correctChoiceIndex: correctChoiceIndex ?? this.correctChoiceIndex,
      isMultipleChoice: isMultipleChoice ?? this.isMultipleChoice,
    );
  }
}
