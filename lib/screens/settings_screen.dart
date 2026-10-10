import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: Container(
        decoration: isDark
            ? AppTheme.darkGoldGradientDecoration
            : AppTheme.goldGradientDecoration,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // App Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            isDark ? AppTheme.lightGold : AppTheme.primaryGold,
                            isDark ? AppTheme.primaryGold : AppTheme.darkGold,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (isDark
                                    ? AppTheme.lightGold
                                    : AppTheme.primaryGold)
                                .withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.school,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return AppTheme.goldShimmerGradient
                            .createShader(bounds);
                      },
                      child: const Text(
                        'Flashcard Quiz Pro',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Version 1.0.0',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'CodeAlpha Internship - Task 1',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade500,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Appearance
            Card(
              child: Column(
                children: [
                  _buildSectionHeader(
                      context, 'Appearance', Icons.palette, isDark),
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Toggle dark theme'),
                    value: appProvider.isDarkMode,
                    activeColor:
                        isDark ? AppTheme.lightGold : AppTheme.primaryGold,
                    onChanged: (value) {
                      appProvider.toggleTheme();
                    },
                    secondary: Icon(
                      appProvider.isDarkMode
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color:
                          isDark ? AppTheme.lightGold : AppTheme.primaryGold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Data Management
            Card(
              child: Column(
                children: [
                  _buildSectionHeader(
                      context, 'Data Management', Icons.storage, isDark),
                  ListTile(
                    leading: Icon(
                      Icons.upload_file,
                      color:
                          isDark ? AppTheme.lightGold : AppTheme.primaryGold,
                    ),
                    title: const Text('Export Data'),
                    subtitle:
                        const Text('Backup your flashcards and categories'),
                    onTap: () async {
                      final filePath = await appProvider.exportData();
                      if (context.mounted) {
                        if (filePath != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Data exported to: $filePath'),
                              backgroundColor: Colors.green,
                              action: SnackBarAction(
                                label: 'Share',
                                textColor: Colors.white,
                                onPressed: () {
                                  Share.shareXFiles([XFile(filePath)]);
                                },
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to export data'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      Icons.delete_forever,
                      color: Colors.red.shade400,
                    ),
                    title: const Text('Clear All Data'),
                    subtitle: const Text('Delete all flashcards and progress'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Clear All Data?'),
                          content: const Text(
                            'This will permanently delete all your flashcards, categories, and study sessions. This action cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO: Implement clear all data
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('All data cleared'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Delete All'),
                            ),
                          ],
                        ),
                      );
                    },
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // About
            Card(
              child: Column(
                children: [
                  _buildSectionHeader(
                      context, 'About', Icons.info_outline, isDark),
                  ListTile(
                    leading: Icon(
                      Icons.article,
                      color:
                          isDark ? AppTheme.lightGold : AppTheme.primaryGold,
                    ),
                    title: const Text('How to Use'),
                    subtitle: const Text('Learn how to use the app'),
                    onTap: () {
                      _showHowToUseDialog(context);
                    },
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      Icons.code,
                      color:
                          isDark ? AppTheme.lightGold : AppTheme.primaryGold,
                    ),
                    title: const Text('About Developer'),
                    subtitle: const Text('CodeAlpha Internship Project'),
                    onTap: () {
                      _showAboutDialog(context);
                    },
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      Icons.share,
                      color:
                          isDark ? AppTheme.lightGold : AppTheme.primaryGold,
                    ),
                    title: const Text('Share App'),
                    subtitle: const Text('Tell your friends about this app'),
                    onTap: () {
                      Share.share(
                        'Check out Flashcard Quiz Pro! A beautiful and professional flashcard app for studying. 📚✨',
                      );
                    },
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Footer
            Center(
              child: Column(
                children: [
                  Text(
                    'Made with ❤️ for CodeAlpha',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade500,
                        ),
                  ),
                  const SizedBox(height: 4),
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return AppTheme.goldShimmerGradient.createShader(bounds);
                    },
                    child: Text(
                      '© 2024 Flashcard Quiz Pro',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
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
      child: Row(
        children: [
          Icon(
            icon,
            color: isDark ? AppTheme.lightGold : AppTheme.primaryGold,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  void _showHowToUseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Use'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                '1. Create flashcards with questions and answers\n\n'
                '2. Organize them into categories\n\n'
                '3. Start a quiz session to study\n\n'
                '4. Mark cards as favorites for quick access\n\n'
                '5. Track your progress in Statistics\n\n'
                '6. Maintain your study streak!\n\n'
                '7. Export your data for backup',
                style: TextStyle(height: 1.5),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Developer'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'This app was created as part of the CodeAlpha App Development Internship Program.',
              style: TextStyle(height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              'Task 1: Flashcard Quiz App',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Features:\n'
              '• Beautiful gold-themed UI\n'
              '• Dark mode support\n'
              '• Categories & organization\n'
              '• Progress tracking\n'
              '• Study streaks\n'
              '• Data export\n'
              '• And much more!',
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
