import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        elevation: 0,
      ),
      body: Container(
        decoration: isDark
            ? AppTheme.darkGoldGradientDecoration
            : AppTheme.goldGradientDecoration,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Overall Stats Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.insights,
                          color: isDark
                              ? AppTheme.lightGold
                              : AppTheme.primaryGold,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Overall Statistics',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppTheme.lightGold
                                    : AppTheme.primaryGold,
                              ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    _buildStatRow(
                      context,
                      'Total Flashcards',
                      appProvider.totalCards.toString(),
                      Icons.collections_bookmark,
                      isDark,
                    ),
                    _buildStatRow(
                      context,
                      'Favorite Cards',
                      appProvider.favoriteCards.toString(),
                      Icons.favorite,
                      isDark,
                    ),
                    _buildStatRow(
                      context,
                      'Study Sessions',
                      appProvider.totalSessions.toString(),
                      Icons.history_edu,
                      isDark,
                    ),
                    _buildStatRow(
                      context,
                      'Current Streak',
                      '${appProvider.studyStreak} days',
                      Icons.local_fire_department,
                      isDark,
                    ),
                    _buildStatRow(
                      context,
                      'Overall Mastery',
                      '${appProvider.overallMastery.toStringAsFixed(1)}%',
                      Icons.emoji_events,
                      isDark,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Mastery Progress
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.trending_up,
                          color: isDark
                              ? AppTheme.lightGold
                              : AppTheme.primaryGold,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Mastery Progress',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            isDark
                                ? AppTheme.warmBrown.withOpacity(0.3)
                                : AppTheme.paleGold.withOpacity(0.3),
                            isDark
                                ? AppTheme.deepBrown.withOpacity(0.2)
                                : AppTheme.lightGold.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${appProvider.overallMastery.toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..shader = AppTheme.goldShimmerGradient
                                    .createShader(
                                  const Rect.fromLTWH(0, 0, 200, 70),
                                ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: appProvider.overallMastery / 100,
                            minHeight: 8,
                            backgroundColor: isDark
                                ? AppTheme.warmBrown
                                : AppTheme.paleGold,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isDark
                                  ? AppTheme.lightGold
                                  : AppTheme.primaryGold,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Recent Sessions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.history,
                          color: isDark
                              ? AppTheme.lightGold
                              : AppTheme.primaryGold,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Recent Sessions',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (appProvider.studySessions.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Icon(
                                Icons.event_busy,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No study sessions yet',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...appProvider.studySessions
                          .take(5)
                          .map((session) => _buildSessionTile(
                                context,
                                session,
                                isDark,
                              ))
                          .toList(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Achievements
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          color: isDark
                              ? AppTheme.lightGold
                              : AppTheme.primaryGold,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Achievements',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildAchievement(
                      context,
                      'First Steps',
                      'Complete your first study session',
                      appProvider.totalSessions > 0,
                      Icons.play_circle,
                      isDark,
                    ),
                    _buildAchievement(
                      context,
                      'Collector',
                      'Create 10 flashcards',
                      appProvider.totalCards >= 10,
                      Icons.collections,
                      isDark,
                    ),
                    _buildAchievement(
                      context,
                      'Week Warrior',
                      'Maintain a 7-day streak',
                      appProvider.studyStreak >= 7,
                      Icons.calendar_today,
                      isDark,
                    ),
                    _buildAchievement(
                      context,
                      'Master',
                      'Achieve 80% overall mastery',
                      appProvider.overallMastery >= 80,
                      Icons.school,
                      isDark,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  isDark ? AppTheme.lightGold : AppTheme.primaryGold,
                  isDark ? AppTheme.primaryGold : AppTheme.darkGold,
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color:
                      isDark ? AppTheme.lightGold : AppTheme.primaryGold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionTile(
    BuildContext context,
    dynamic session,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isDark
                ? AppTheme.warmBrown.withOpacity(0.2)
                : AppTheme.paleGold.withOpacity(0.2),
            isDark
                ? AppTheme.deepBrown.withOpacity(0.1)
                : AppTheme.lightGold.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark
              ? AppTheme.primaryGold.withOpacity(0.3)
              : AppTheme.darkGold.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.history_edu,
            color: isDark ? AppTheme.lightGold : AppTheme.primaryGold,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMM dd, yyyy').format(session.startTime),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${session.cardsStudied} cards • ${session.accuracy.toStringAsFixed(0)}% accuracy',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievement(
    BuildContext context,
    String title,
    String description,
    bool achieved,
    IconData icon,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: achieved
            ? LinearGradient(
                colors: [
                  isDark
                      ? AppTheme.lightGold.withOpacity(0.3)
                      : AppTheme.primaryGold.withOpacity(0.2),
                  isDark
                      ? AppTheme.primaryGold.withOpacity(0.2)
                      : AppTheme.darkGold.withOpacity(0.1),
                ],
              )
            : null,
        color: achieved ? null : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: achieved
              ? (isDark ? AppTheme.lightGold : AppTheme.primaryGold)
              : Colors.grey.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: achieved
                  ? LinearGradient(
                      colors: [
                        isDark ? AppTheme.lightGold : AppTheme.primaryGold,
                        isDark ? AppTheme.primaryGold : AppTheme.darkGold,
                      ],
                    )
                  : null,
              color: achieved ? null : Colors.grey.withOpacity(0.3),
            ),
            child: Icon(
              icon,
              color: achieved ? Colors.white : Colors.grey.shade600,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: achieved
                        ? (isDark ? AppTheme.lightGold : AppTheme.primaryGold)
                        : null,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (achieved)
            Icon(
              Icons.check_circle,
              color: isDark ? AppTheme.lightGold : AppTheme.primaryGold,
            ),
        ],
      ),
    );
  }
}
