import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'flashcard_screen.dart';
import 'manage_flashcards_screen.dart';
import 'document_upload_screen.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  String? _selectedCategoryId;
  bool _favoritesOnly = false;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter flashcards
    var flashcards = _selectedCategoryId != null
        ? appProvider.getFlashcardsByCategory(_selectedCategoryId!)
        : appProvider.flashcards;

    if (_favoritesOnly) {
      flashcards = flashcards.where((c) => c.isFavorite).toList();
    }

    if (_searchQuery.isNotEmpty) {
      flashcards = flashcards.where((card) {
        return card.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            card.answer.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return Scaffold(
      body: Container(
        decoration: isDark
            ? AppTheme.darkGoldGradientDecoration
            : AppTheme.goldGradientDecoration,
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Flashcard Quiz Pro',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        isDark ? AppTheme.deepBrown : AppTheme.primaryGold,
                        isDark ? AppTheme.warmBrown : AppTheme.darkGold,
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Decorative circles
                      Positioned(
                        top: -50,
                        right: -50,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -30,
                        left: -30,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      // Centered icon
                      Center(
                        child: Icon(
                          Icons.school,
                          size: 80,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            context,
                            'Total Cards',
                            appProvider.totalCards.toString(),
                            Icons.collections_bookmark,
                            isDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            'Study Streak',
                            '${appProvider.studyStreak} days',
                            Icons.local_fire_department,
                            isDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            context,
                            'Favorites',
                            appProvider.favoriteCards.toString(),
                            Icons.favorite,
                            isDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            'Mastery',
                            '${appProvider.overallMastery.toStringAsFixed(0)}%',
                            Icons.emoji_events,
                            isDark,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Search Bar
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search flashcards...',
                        prefixIcon: Icon(
                          Icons.search,
                          color: isDark ? AppTheme.lightGold : AppTheme.primaryGold,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Filters
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // All Categories
                          FilterChip(
                            selected: _selectedCategoryId == null,
                            label: const Text('All'),
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategoryId = null;
                              });
                            },
                            avatar: const Icon(Icons.apps, size: 18),
                          ),
                          const SizedBox(width: 8),

                          // Category filters
                          ...appProvider.categories.map((category) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                selected: _selectedCategoryId == category.id,
                                label: Text(category.name),
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedCategoryId =
                                        selected ? category.id : null;
                                  });
                                },
                                avatar: Icon(category.icon, size: 18),
                              ),
                            );
                          }).toList(),

                          const SizedBox(width: 8),
                          // Favorites filter
                          FilterChip(
                            selected: _favoritesOnly,
                            label: const Text('Favorites'),
                            onSelected: (selected) {
                              setState(() {
                                _favoritesOnly = selected;
                              });
                            },
                            avatar: const Icon(Icons.favorite, size: 18),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Quick Actions
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: flashcards.isEmpty
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FlashcardScreen(
                                          flashcards: flashcards,
                                        ),
                                      ),
                                    );
                                  },
                            icon: const Icon(Icons.play_arrow, size: 28),
                            label: const Text('Start Quiz'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ManageFlashcardsScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit, size: 28),
                            label: const Text('Manage'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Document Upload Button (Featured)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DocumentUploadScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.upload_file, size: 28),
                        label: const Text('Upload Document & Generate Flashcards'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: isDark ? AppTheme.lightGold : AppTheme.primaryGold,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Flashcard Count
                    Text(
                      '${flashcards.length} flashcard${flashcards.length != 1 ? 's' : ''} available',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: isDark
                                ? AppTheme.lightGold
                                : AppTheme.primaryGold,
                            fontWeight: FontWeight.bold,
                          ),
                    ),

                    if (flashcards.isEmpty) ...[
                      const SizedBox(height: 40),
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No flashcards found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your filters or add new flashcards',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    bool isDark,
  ) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isDark
                  ? AppTheme.warmBrown.withOpacity(0.3)
                  : AppTheme.paleGold.withOpacity(0.3),
              isDark
                  ? AppTheme.deepBrown.withOpacity(0.2)
                  : AppTheme.lightGold.withOpacity(0.2),
            ],
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isDark ? AppTheme.lightGold : AppTheme.primaryGold,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.lightGold : AppTheme.primaryGold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
