import '../../domain/entities/flashcard_entity.dart';

/// Sample flashcards for initial app load
class SampleFlashcards {
  static List<FlashcardEntity> get all => [
        // Mathematics (5 cards)
        FlashcardEntity(
          id: 'sample_1',
          question: 'What is 15 × 12?',
          answer: '180',
          categoryId: 'mathematics',
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
        FlashcardEntity(
          id: 'sample_2',
          question: 'What is the Pythagorean theorem?',
          answer: 'a² + b² = c²\n\nIn a right triangle, the square of the hypotenuse equals the sum of squares of the other two sides.',
          categoryId: 'mathematics',
          createdAt: DateTime.now().subtract(const Duration(days: 9)),
        ),
        FlashcardEntity(
          id: 'sample_3',
          question: 'What is the value of π (pi)?',
          answer: 'π ≈ 3.14159\n\nPi is the ratio of a circle\'s circumference to its diameter.',
          categoryId: 'mathematics',
          createdAt: DateTime.now().subtract(const Duration(days: 8)),
        ),
        FlashcardEntity(
          id: 'sample_4',
          question: 'What is the formula for the area of a circle?',
          answer: 'A = πr²\n\nWhere r is the radius of the circle.',
          categoryId: 'mathematics',
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
        ),
        FlashcardEntity(
          id: 'sample_5',
          question: 'What is 25% of 200?',
          answer: '50\n\nCalculation: (25/100) × 200 = 50',
          categoryId: 'mathematics',
          createdAt: DateTime.now().subtract(const Duration(days: 6)),
        ),

        // English (5 cards)
        FlashcardEntity(
          id: 'sample_6',
          question: 'What is a noun?',
          answer: 'A noun is a word that names a person, place, thing, or idea.\n\nExamples: book, London, happiness, teacher',
          categoryId: 'english',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        FlashcardEntity(
          id: 'sample_7',
          question: 'What is the difference between "their," "there," and "they\'re"?',
          answer: '• Their = possessive (their book)\n• There = location (over there)\n• They\'re = they are (they\'re happy)',
          categoryId: 'english',
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
        FlashcardEntity(
          id: 'sample_8',
          question: 'What is a metaphor?',
          answer: 'A metaphor is a figure of speech that compares two things without using "like" or "as."\n\nExample: "Time is money"',
          categoryId: 'english',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        FlashcardEntity(
          id: 'sample_9',
          question: 'What are the three main verb tenses?',
          answer: '1. Past - happened before now\n2. Present - happening now\n3. Future - will happen later',
          categoryId: 'english',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        FlashcardEntity(
          id: 'sample_10',
          question: 'What is an adjective?',
          answer: 'An adjective is a word that describes or modifies a noun.\n\nExamples: beautiful, large, quick, happy',
          categoryId: 'english',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),

        // Science (5 cards)
        FlashcardEntity(
          id: 'sample_11',
          question: 'What are the three states of matter?',
          answer: '1. Solid - definite shape and volume\n2. Liquid - definite volume, takes container shape\n3. Gas - no definite shape or volume',
          categoryId: 'science',
          createdAt: DateTime.now(),
        ),
        FlashcardEntity(
          id: 'sample_12',
          question: 'What is photosynthesis?',
          answer: 'Photosynthesis is the process by which plants convert sunlight, water, and carbon dioxide into glucose and oxygen.\n\n6CO₂ + 6H₂O + light → C₆H₁₂O₆ + 6O₂',
          categoryId: 'science',
          createdAt: DateTime.now(),
        ),
        FlashcardEntity(
          id: 'sample_13',
          question: 'What is the speed of light?',
          answer: '299,792,458 meters per second\n\nOr approximately 300,000 km/s or 186,000 miles/s',
          categoryId: 'science',
          createdAt: DateTime.now(),
        ),
        FlashcardEntity(
          id: 'sample_14',
          question: 'What is DNA?',
          answer: 'DNA (Deoxyribonucleic Acid) is the molecule that carries genetic information in living organisms.\n\nIt has a double helix structure discovered by Watson and Crick.',
          categoryId: 'science',
          createdAt: DateTime.now(),
        ),
        FlashcardEntity(
          id: 'sample_15',
          question: 'What are the planets in our solar system?',
          answer: 'In order from the Sun:\n1. Mercury\n2. Venus\n3. Earth\n4. Mars\n5. Jupiter\n6. Saturn\n7. Uranus\n8. Neptune',
          categoryId: 'science',
          createdAt: DateTime.now(),
        ),

        // General Knowledge (3 cards)
        FlashcardEntity(
          id: 'sample_16',
          question: 'What is the capital of France?',
          answer: 'Paris\n\nParis is also known as the "City of Light" and is famous for the Eiffel Tower.',
          categoryId: 'general',
          createdAt: DateTime.now(),
        ),
        FlashcardEntity(
          id: 'sample_17',
          question: 'Who painted the Mona Lisa?',
          answer: 'Leonardo da Vinci\n\nThe painting was created between 1503-1519 and is displayed in the Louvre Museum in Paris.',
          categoryId: 'general',
          createdAt: DateTime.now(),
        ),
        FlashcardEntity(
          id: 'sample_18',
          question: 'What is the largest ocean on Earth?',
          answer: 'The Pacific Ocean\n\nIt covers more than 63 million square miles (165 million km²) and is larger than all of Earth\'s land area combined.',
          categoryId: 'general',
          createdAt: DateTime.now(),
        ),
      ];
}
