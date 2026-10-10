import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'add_edit_flashcard_screen.dart';

class ManageFlashcardsScreen extends StatelessWidget {
  const ManageFlashcardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final flashcards = appProvider.flashcards;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Flashcards'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: isDark
            ? AppTheme.darkGoldGradientDecoration
            : AppTheme.goldGradientDecoration,
        child: flashcards.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.note_add,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No flashcards yet',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the + button to add your first flashcard',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: flashcards.length,
                itemBuilder: (context, index) {
                  final flashcard = flashcards[index];
                  final category = appProvider.getCategoryById(flashcard.categoryId);
                  
                  return Slidable(
                    key: Key(flashcard.id),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddEditFlashcardScreen(
                                  flashcard: flashcard,
                                ),
                              ),
                            );
                            
                            if (result != null) {
                              appProvider.updateFlashcard(flashcard.id, result);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Flashcard updated!'),
                                    backgroundColor: isDark ? AppTheme.primaryGold : AppTheme.darkGold,
                                  ),
                                );
                              }
                            }
                          },
                          backgroundColor: isDark ? AppTheme.primaryGold : AppTheme.darkGold,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                        SlidableAction(
                          onPressed: (_) async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Flashcard'),
                                content: const Text(
                                  'Are you sure you want to delete this flashcard?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              appProvider.deleteFlashcard(flashcard.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Flashcard deleted!'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEditFlashcardScreen(
                                flashcard: flashcard,
                              ),
                            ),
                          );
                          
                          if (result != null) {
                            appProvider.updateFlashcard(flashcard.id, result);
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                (isDark
                                        ? AppTheme.warmBrown
                                        : category?.color ?? AppTheme.paleGold)
                                    .withOpacity(0.1),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      flashcard.question,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      flashcard.isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: flashcard.isFavorite
                                          ? (isDark
                                              ? AppTheme.lightGold
                                              : AppTheme.primaryGold)
                                          : null,
                                    ),
                                    onPressed: () {
                                      appProvider.toggleFavorite(flashcard.id);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                flashcard.answer,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  if (category != null) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            (isDark
                                                    ? AppTheme.lightGold
                                                    : category.color)
                                                .withOpacity(0.2),
                                            (isDark
                                                    ? AppTheme.primaryGold
                                                    : category.color)
                                                .withOpacity(0.1),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isDark
                                              ? AppTheme.primaryGold
                                              : category.color,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            category.icon,
                                            size: 14,
                                            color: isDark
                                                ? AppTheme.lightGold
                                                : category.color,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            category.name,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isDark
                                                  ? AppTheme.lightGold
                                                  : category.color,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                  if (flashcard.masteryPercentage > 0) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            (isDark
                                                    ? AppTheme.lightGold
                                                    : AppTheme.primaryGold)
                                                .withOpacity(0.2),
                                            (isDark
                                                    ? AppTheme.primaryGold
                                                    : AppTheme.darkGold)
                                                .withOpacity(0.1),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.emoji_events,
                                            size: 14,
                                            color: isDark
                                                ? AppTheme.lightGold
                                                : AppTheme.primaryGold,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '${flashcard.masteryPercentage.toStringAsFixed(0)}%',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isDark
                                                  ? AppTheme.lightGold
                                                  : AppTheme.primaryGold,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditFlashcardScreen(),
            ),
          );
          
          if (result != null) {
            appProvider.addFlashcard(result);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Flashcard added!'),
                  backgroundColor: isDark ? AppTheme.lightGold : AppTheme.primaryGold,
                ),
              );
            }
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Flashcard'),
      ),
    );
  }
}

