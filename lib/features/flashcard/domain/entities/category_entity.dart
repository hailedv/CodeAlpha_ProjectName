import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Category Entity for organizing flashcards
class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  @override
  List<Object?> get props => [id, name, icon, color];
}

/// Predefined categories
class Categories {
  static const english = CategoryEntity(
    id: 'english',
    name: 'English',
    icon: Icons.menu_book,
    color: Color(0xFF2196F3), // Blue
  );

  static const mathematics = CategoryEntity(
    id: 'mathematics',
    name: 'Mathematics',
    icon: Icons.calculate,
    color: Color(0xFFE91E63), // Pink
  );

  static const science = CategoryEntity(
    id: 'science',
    name: 'Science',
    icon: Icons.science,
    color: Color(0xFF4CAF50), // Green
  );

  static const history = CategoryEntity(
    id: 'history',
    name: 'History',
    icon: Icons.history_edu,
    color: Color(0xFFFF9800), // Orange
  );

  static const geography = CategoryEntity(
    id: 'geography',
    name: 'Geography',
    icon: Icons.public,
    color: Color(0xFF00BCD4), // Cyan
  );

  static const programming = CategoryEntity(
    id: 'programming',
    name: 'Programming',
    icon: Icons.code,
    color: Color(0xFF9C27B0), // Purple
  );

  static const general = CategoryEntity(
    id: 'general',
    name: 'General Knowledge',
    icon: Icons.lightbulb,
    color: Color(0xFFFFC107), // Amber
  );

  static const other = CategoryEntity(
    id: 'other',
    name: 'Other',
    icon: Icons.category,
    color: Color(0xFF607D8B), // Blue Grey
  );

  /// Get all available categories
  static List<CategoryEntity> get all => [
        english,
        mathematics,
        science,
        history,
        geography,
        programming,
        general,
        other,
      ];

  /// Get category by ID
  static CategoryEntity getById(String id) {
    return all.firstWhere(
      (category) => category.id == id,
      orElse: () => general,
    );
  }
}
