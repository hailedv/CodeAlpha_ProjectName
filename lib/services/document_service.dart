import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../models/flashcard.dart';

class DocumentService {
  /// Pick a document file from the device
  static Future<File?> pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'txt', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      print('Error picking document: $e');
      return null;
    }
  }

  /// Extract text from a document file
  static Future<String?> extractTextFromDocument(File file) async {
    try {
      String extension = file.path.split('.').last.toLowerCase();

      switch (extension) {
        case 'txt':
          return await file.readAsString();
        
        case 'pdf':
          return await _extractTextFromPdf(file);
        
        case 'doc':
        case 'docx':
          // For Word documents, we'll read as text (simplified approach)
          // In production, you'd use a proper Word parsing library
          try {
            return await file.readAsString();
          } catch (e) {
            return 'Word document detected. Please convert to PDF or TXT for best results.';
          }
        
        default:
          return null;
      }
    } catch (e) {
      print('Error extracting text: $e');
      return null;
    }
  }

  /// Extract text from PDF file using Syncfusion
  static Future<String> _extractTextFromPdf(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      
      String extractedText = '';
      for (int i = 0; i < document.pages.count; i++) {
        extractedText += PdfTextExtractor(document).extractText(startPageIndex: i, endPageIndex: i);
        extractedText += '\n\n';
      }
      
      document.dispose();
      return extractedText.trim();
    } catch (e) {
      print('Error extracting PDF text: $e');
      return '';
    }
  }

  /// Generate flashcards from extracted text
  /// This uses pattern matching to find Q&A pairs or splits text intelligently
  static List<Flashcard> generateFlashcardsFromText(String text, {String categoryId = 'imported'}) {
    List<Flashcard> flashcards = [];
    
    // Method 1: Look for explicit Q&A patterns
    flashcards.addAll(_extractQAPairs(text, categoryId));
    
    // Method 2: If no Q&A found, create flashcards from key sentences
    if (flashcards.isEmpty) {
      flashcards.addAll(_createFlashcardsFromContent(text, categoryId));
    }
    
    return flashcards;
  }

  /// Extract Q&A pairs from text (looks for Question: Answer: patterns)
  static List<Flashcard> _extractQAPairs(String text, String categoryId) {
    List<Flashcard> flashcards = [];
    
    // Pattern 1: Q: ... A: ...
    RegExp qaPattern1 = RegExp(
      r'Q:\s*(.+?)\s*A:\s*(.+?)(?=Q:|$)',
      multiLine: true,
      dotAll: true,
    );
    
    // Pattern 2: Question: ... Answer: ...
    RegExp qaPattern2 = RegExp(
      r'Question:\s*(.+?)\s*Answer:\s*(.+?)(?=Question:|$)',
      multiLine: true,
      dotAll: true,
      caseSensitive: false,
    );
    
    // Pattern 3: Numbered questions: 1. ... Answer: ...
    RegExp qaPattern3 = RegExp(
      r'\d+\.\s*(.+?)\s*(?:Answer:|A:)\s*(.+?)(?=\d+\.|$)',
      multiLine: true,
      dotAll: true,
      caseSensitive: false,
    );

    // Try all patterns
    for (var pattern in [qaPattern1, qaPattern2, qaPattern3]) {
      Iterable<RegExpMatch> matches = pattern.allMatches(text);
      
      for (var match in matches) {
        String question = match.group(1)?.trim() ?? '';
        String answer = match.group(2)?.trim() ?? '';
        
        if (question.isNotEmpty && answer.isNotEmpty) {
          flashcards.add(Flashcard(
            id: DateTime.now().millisecondsSinceEpoch.toString() + '_' + flashcards.length.toString(),
            question: question,
            answer: answer,
            categoryId: categoryId,
            tags: ['imported', 'document'],
          ));
        }
      }
    }
    
    return flashcards;
  }

  /// Create flashcards from general content by splitting into sentences
  static List<Flashcard> _createFlashcardsFromContent(String text, String categoryId) {
    List<Flashcard> flashcards = [];
    
    // Split into paragraphs
    List<String> paragraphs = text.split('\n\n')
        .where((p) => p.trim().isNotEmpty && p.trim().length > 20)
        .toList();
    
    for (int i = 0; i < paragraphs.length && i < 10; i++) {
      String paragraph = paragraphs[i].trim();
      
      // Skip very long paragraphs
      if (paragraph.length > 500) {
        continue;
      }
      
      // Create a question from the first sentence
      List<String> sentences = paragraph.split(RegExp(r'[.!?]\s+'));
      if (sentences.length >= 2) {
        String question = _generateQuestionFromSentence(sentences[0]);
        String answer = paragraph;
        
        flashcards.add(Flashcard(
          id: DateTime.now().millisecondsSinceEpoch.toString() + '_' + i.toString(),
          question: question,
          answer: answer,
          categoryId: categoryId,
          tags: ['imported', 'auto-generated'],
        ));
      }
    }
    
    return flashcards;
  }

  /// Generate a question from a sentence
  static String _generateQuestionFromSentence(String sentence) {
    sentence = sentence.trim();
    
    // Remove trailing punctuation
    sentence = sentence.replaceAll(RegExp(r'[.!?]+$'), '');
    
    // Simple question templates
    List<String> templates = [
      'What is $sentence?',
      'Explain: $sentence',
      'What do you know about: $sentence?',
      'Define: $sentence',
    ];
    
    // Pick a random template
    return templates[sentence.length % templates.length];
  }

  /// Create multiple-choice flashcards from text
  static List<Flashcard> generateMultipleChoiceFromText(String text, {String categoryId = 'imported'}) {
    List<Flashcard> flashcards = [];
    
    // Extract key facts
    List<String> sentences = text.split(RegExp(r'[.!?]\s+'))
        .where((s) => s.trim().length > 20 && s.trim().length < 200)
        .toList();
    
    for (int i = 0; i < sentences.length && flashcards.length < 5; i++) {
      String sentence = sentences[i].trim();
      
      // Create a fill-in-the-blank question
      List<String> words = sentence.split(' ');
      if (words.length < 5) continue;
      
      // Find an important word (usually nouns, longer words)
      String? targetWord;
      int targetIndex = -1;
      for (int j = 0; j < words.length; j++) {
        if (words[j].length > 5 && !['the', 'and', 'but', 'with', 'from', 'this', 'that'].contains(words[j].toLowerCase())) {
          targetWord = words[j];
          targetIndex = j;
          break;
        }
      }
      
      if (targetWord != null && targetIndex != -1) {
        // Create the question with a blank
        words[targetIndex] = '_____';
        String question = 'Fill in the blank: ${words.join(' ')}';
        
        // Generate choices (correct answer + 3 distractors)
        List<String> choices = [
          targetWord,
          _generateDistractor(targetWord, 1),
          _generateDistractor(targetWord, 2),
          _generateDistractor(targetWord, 3),
        ];
        choices.shuffle();
        
        int correctIndex = choices.indexOf(targetWord);
        
        flashcards.add(Flashcard(
          id: DateTime.now().millisecondsSinceEpoch.toString() + '_mcq_' + flashcards.length.toString(),
          question: question,
          answer: 'The correct answer is "$targetWord". $sentence',
          categoryId: categoryId,
          tags: ['imported', 'multiple-choice'],
          isMultipleChoice: true,
          choices: choices,
          correctChoiceIndex: correctIndex,
        ));
      }
    }
    
    return flashcards;
  }

  /// Generate a distractor (wrong answer) for multiple choice
  static String _generateDistractor(String word, int seed) {
    // Simple distractor generation (in production, use a dictionary or AI)
    List<String> prefixes = ['pre-', 'un-', 'non-', 're-', 'de-', 'mis-'];
    List<String> suffixes = ['-tion', '-ment', '-ness', '-ing', '-ed', '-ly'];
    
    if (seed == 1 && word.length > 3) {
      return word.substring(0, word.length - 2) + 'tion';
    } else if (seed == 2 && word.length > 4) {
      return 'non-${word.toLowerCase()}';
    } else {
      return word.substring(0, 1) + word.substring(1).toLowerCase() + 'ment';
    }
  }

  /// Preview flashcards count from document
  static Future<Map<String, dynamic>> analyzeDocument(File file) async {
    String? text = await extractTextFromDocument(file);
    
    if (text == null || text.isEmpty) {
      return {
        'success': false,
        'message': 'Could not extract text from document',
      };
    }
    
    List<Flashcard> qaCards = generateFlashcardsFromText(text);
    List<Flashcard> mcqCards = generateMultipleChoiceFromText(text);
    
    return {
      'success': true,
      'wordCount': text.split(' ').length,
      'qaCount': qaCards.length,
      'mcqCount': mcqCards.length,
      'totalCards': qaCards.length + mcqCards.length,
      'text': text,
    };
  }
}
