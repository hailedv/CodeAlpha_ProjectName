import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/document_service.dart';
import '../providers/app_provider.dart';
import '../models/flashcard.dart';
import '../theme/app_theme.dart';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  File? _selectedFile;
  bool _isProcessing = false;
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResult;
  String _selectedCategoryId = 'default';
  bool _generateQA = true;
  bool _generateMCQ = true;

  Future<void> _pickDocument() async {
    setState(() {
      _isAnalyzing = true;
      _analysisResult = null;
    });

    File? file = await DocumentService.pickDocument();
    
    if (file != null) {
      setState(() {
        _selectedFile = file;
      });

      // Analyze the document
      Map<String, dynamic> analysis = await DocumentService.analyzeDocument(file);
      
      setState(() {
        _analysisResult = analysis;
        _isAnalyzing = false;
      });

      if (!analysis['success']) {
        _showErrorDialog(analysis['message']);
      }
    } else {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  Future<void> _processDocument() async {
    if (_selectedFile == null || _analysisResult == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      String text = _analysisResult!['text'];
      List<Flashcard> allCards = [];

      // Generate Q&A flashcards
      if (_generateQA) {
        allCards.addAll(DocumentService.generateFlashcardsFromText(text, categoryId: _selectedCategoryId));
      }

      // Generate Multiple Choice flashcards
      if (_generateMCQ) {
        allCards.addAll(DocumentService.generateMultipleChoiceFromText(text, categoryId: _selectedCategoryId));
      }

      if (allCards.isEmpty) {
        _showErrorDialog('Could not generate flashcards. Try a document with clear Q&A format or meaningful content.');
        setState(() {
          _isProcessing = false;
        });
        return;
      }

      // Add to provider
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      for (var card in allCards) {
        appProvider.addFlashcard(card);
      }

      setState(() {
        _isProcessing = false;
      });

      // Show success dialog
      _showSuccessDialog(allCards.length);
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _showErrorDialog('Error processing document: $e');
    }
  }

  void _showSuccessDialog(int count) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.primaryGold),
            const SizedBox(width: 12),
            const Text('Success!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.celebration, size: 64, color: AppTheme.lightGold),
            const SizedBox(height: 16),
            Text(
              'Generated $count flashcards from your document!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to home
            },
            child: const Text('View Flashcards'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _selectedFile = null;
                _analysisResult = null;
              });
            },
            child: const Text('Upload Another'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 12),
            Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Document'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: isDark ? AppTheme.darkGoldGradientDecoration : AppTheme.goldGradientDecoration,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        isDark ? AppTheme.lightGold : AppTheme.primaryGold,
                        isDark ? AppTheme.primaryGold : AppTheme.darkGold,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.upload_file, size: 64, color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'Upload & Generate Flashcards',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Upload a document and AI will create flashcards automatically',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Supported formats
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.warmBrown.withOpacity(0.3) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: isDark ? AppTheme.lightGold : AppTheme.primaryGold),
                          const SizedBox(width: 8),
                          const Text(
                            'Supported Formats',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildFormatItem('PDF', 'Best for formatted documents'),
                      _buildFormatItem('TXT', 'Plain text files'),
                      _buildFormatItem('DOC/DOCX', 'Microsoft Word documents'),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Upload button
                SizedBox(
                  height: 60,
                  child: ElevatedButton.icon(
                    onPressed: _isAnalyzing || _isProcessing ? null : _pickDocument,
                    icon: _isAnalyzing
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.folder_open, size: 28),
                    label: Text(
                      _isAnalyzing ? 'Analyzing...' : 'Choose Document',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                // Analysis result
                if (_analysisResult != null && _analysisResult!['success']) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.withOpacity(0.2),
                          Colors.green.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 8),
                            const Text(
                              'Document Analyzed',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text('📄 File: ${_selectedFile?.path.split('/').last ?? 'Unknown'}'),
                        const SizedBox(height: 8),
                        Text('📝 Words: ${_analysisResult!['wordCount']}'),
                        const SizedBox(height: 8),
                        Text('🎯 Potential Flashcards: ${_analysisResult!['totalCards']}'),
                        const SizedBox(height: 8),
                        Text('  • Q&A Cards: ${_analysisResult!['qaCount']}'),
                        Text('  • Multiple Choice: ${_analysisResult!['mcqCount']}'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Options
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.warmBrown.withOpacity(0.3) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Generation Options',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        
                        // Category dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedCategoryId,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            prefixIcon: const Icon(Icons.category),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: appProvider.categories.map((category) {
                            return DropdownMenuItem(
                              value: category.id,
                              child: Row(
                                children: [
                                  Icon(category.icon, size: 20),
                                  const SizedBox(width: 8),
                                  Text(category.name),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedCategoryId = value;
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 16),

                        // Card type toggles
                        SwitchListTile(
                          title: const Text('Generate Q&A Cards'),
                          subtitle: Text('${_analysisResult!['qaCount']} cards'),
                          value: _generateQA,
                          onChanged: (value) {
                            setState(() {
                              _generateQA = value;
                            });
                          },
                          activeColor: AppTheme.primaryGold,
                        ),

                        SwitchListTile(
                          title: const Text('Generate Multiple Choice'),
                          subtitle: Text('${_analysisResult!['mcqCount']} cards'),
                          value: _generateMCQ,
                          onChanged: (value) {
                            setState(() {
                              _generateMCQ = value;
                            });
                          },
                          activeColor: AppTheme.primaryGold,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Generate button
                  SizedBox(
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: _isProcessing || (!_generateQA && !_generateMCQ) ? null : _processDocument,
                      icon: _isProcessing
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.auto_awesome, size: 28),
                      label: Text(
                        _isProcessing ? 'Generating...' : 'Generate Flashcards',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormatItem(String format, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green.shade400, size: 20),
          const SizedBox(width: 8),
          Text(
            format,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Text('- $description', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        ],
      ),
    );
  }
}
