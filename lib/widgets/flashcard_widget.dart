import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import '../theme/app_theme.dart';

class FlashcardWidget extends StatefulWidget {
  final Flashcard flashcard;
  final bool showAnswer;
  final Function(int)? onChoiceSelected;
  final int? selectedChoiceIndex;

  const FlashcardWidget({
    super.key,
    required this.flashcard,
    required this.showAnswer,
    this.onChoiceSelected,
    this.selectedChoiceIndex,
  });

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: widget.showAnswer 
              ? (isDark ? AppTheme.lightGold : AppTheme.primaryGold)
              : (isDark ? AppTheme.primaryGold : AppTheme.darkGold),
          width: 2,
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: widget.showAnswer
                ? [
                    isDark 
                        ? AppTheme.warmBrown.withOpacity(0.5)
                        : AppTheme.paleGold.withOpacity(0.3),
                    isDark 
                        ? AppTheme.deepBrown.withOpacity(0.3)
                        : AppTheme.lightGold.withOpacity(0.2),
                  ]
                : [
                    isDark 
                        ? AppTheme.deepBrown.withOpacity(0.5)
                        : AppTheme.cream.withOpacity(0.5),
                    isDark 
                        ? AppTheme.warmBrown.withOpacity(0.3)
                        : AppTheme.paleGold.withOpacity(0.3),
                  ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with gold container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      isDark ? AppTheme.lightGold : AppTheme.primaryGold,
                      isDark ? AppTheme.primaryGold : AppTheme.darkGold,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? AppTheme.lightGold : AppTheme.primaryGold).withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  widget.showAnswer ? Icons.lightbulb : Icons.help_outline,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              
              // Label
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      isDark ? AppTheme.lightGold : AppTheme.primaryGold,
                      isDark ? AppTheme.primaryGold : AppTheme.darkGold,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? AppTheme.lightGold : AppTheme.primaryGold).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  widget.showAnswer ? 'ANSWER' : 'QUESTION',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Question
              Text(
                widget.flashcard.question,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                  color: isDark ? AppTheme.lightGold : AppTheme.deepBrown,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // Multiple Choice Options or Answer
              if (widget.flashcard.isMultipleChoice && !widget.showAnswer) ...[
                ...List.generate(
                  widget.flashcard.choices!.length,
                  (index) => _buildChoiceOption(
                    context,
                    widget.flashcard.choices![index],
                    index,
                    isDark,
                  ),
                ),
              ] else if (widget.showAnswer) ...[
                // Show Answer
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: (isDark ? AppTheme.lightGold : AppTheme.primaryGold).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppTheme.lightGold : AppTheme.primaryGold,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    widget.flashcard.answer,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.6,
                      color: isDark ? AppTheme.lightGold : AppTheme.deepBrown,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              
              // Hint if available and showing question
              if (!widget.showAnswer && widget.flashcard.hint != null && widget.flashcard.hint!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (isDark ? AppTheme.warmBrown : AppTheme.paleGold).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? AppTheme.primaryGold : AppTheme.darkGold,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.tips_and_updates,
                        size: 16,
                        color: isDark ? AppTheme.lightGold : AppTheme.darkGold,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Hint: ${widget.flashcard.hint}',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? AppTheme.lightGold : AppTheme.darkGold,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              // Tags if available
              if (widget.flashcard.tags.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: widget.flashcard.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            (isDark ? AppTheme.primaryGold : AppTheme.darkGold).withOpacity(0.2),
                            (isDark ? AppTheme.darkGold : AppTheme.primaryGold).withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? AppTheme.primaryGold : AppTheme.darkGold,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '#$tag',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppTheme.lightGold : AppTheme.darkGold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceOption(BuildContext context, String choice, int index, bool isDark) {
    final isSelected = widget.selectedChoiceIndex == index;
    final isCorrect = widget.flashcard.correctChoiceIndex == index;
    final showResult = widget.showAnswer && isSelected;
    
    final letters = ['A', 'B', 'C', 'D', 'E', 'F'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onChoiceSelected != null && !widget.showAnswer
              ? () => widget.onChoiceSelected!(index)
              : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        (isDark ? AppTheme.lightGold : AppTheme.primaryGold).withOpacity(0.3),
                        (isDark ? AppTheme.primaryGold : AppTheme.darkGold).withOpacity(0.2),
                      ],
                    )
                  : null,
              color: isSelected ? null : (isDark ? AppTheme.warmBrown.withOpacity(0.2) : Colors.white),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? (isDark ? AppTheme.lightGold : AppTheme.primaryGold)
                    : (isDark ? AppTheme.primaryGold.withOpacity(0.3) : AppTheme.darkGold.withOpacity(0.3)),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Letter badge
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              isDark ? AppTheme.lightGold : AppTheme.primaryGold,
                              isDark ? AppTheme.primaryGold : AppTheme.darkGold,
                            ],
                          )
                        : null,
                    color: isSelected ? null : (isDark ? AppTheme.warmBrown.withOpacity(0.3) : AppTheme.paleGold.withOpacity(0.5)),
                  ),
                  child: Center(
                    child: Text(
                      letters[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : (isDark ? AppTheme.lightGold : AppTheme.darkGold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Choice text
                Expanded(
                  child: Text(
                    choice,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isDark ? Colors.white : AppTheme.deepBrown,
                    ),
                  ),
                ),
                // Check/Cross icon when answer is shown
                if (showResult) ...[
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: isCorrect ? Colors.green : Colors.red,
                    size: 24,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

