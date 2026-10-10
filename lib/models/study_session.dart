class StudySession {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final int cardsStudied;
  final int correctAnswers;
  final int totalTime; // in seconds
  final String categoryId;

  StudySession({
    required this.id,
    required this.startTime,
    this.endTime,
    this.cardsStudied = 0,
    this.correctAnswers = 0,
    this.totalTime = 0,
    this.categoryId = 'default',
  });

  double get accuracy {
    if (cardsStudied == 0) return 0.0;
    return (correctAnswers / cardsStudied) * 100;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'cardsStudied': cardsStudied,
      'correctAnswers': correctAnswers,
      'totalTime': totalTime,
      'categoryId': categoryId,
    };
  }

  factory StudySession.fromJson(Map<String, dynamic> json) {
    return StudySession(
      id: json['id'],
      startTime: DateTime.parse(json['startTime']),
      endTime:
          json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      cardsStudied: json['cardsStudied'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
      totalTime: json['totalTime'] ?? 0,
      categoryId: json['categoryId'] ?? 'default',
    );
  }

  StudySession copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    int? cardsStudied,
    int? correctAnswers,
    int? totalTime,
    String? categoryId,
  }) {
    return StudySession(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      cardsStudied: cardsStudied ?? this.cardsStudied,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      totalTime: totalTime ?? this.totalTime,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
