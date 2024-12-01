import 'package:flutter/material.dart';
import '../widgets/flashcard.dart';
import '../widgets/quiz_question.dart';
import '../services/api_service.dart';

class FlashcardPage extends StatefulWidget {
  const FlashcardPage({super.key});

  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<Map<String, dynamic>> _content = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchContent();
  }

  Future<void> _fetchContent() async {
    const samplePdfText = "Sample PDF content to generate flashcards and questions.";
    try {
      final items = await _apiService.extractFlashcardsAndQuestions(samplePdfText);
      setState(() {
        _content = _parseContent(items);
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _parseContent(List<String> items) {
    return items
        .map<Map<String, dynamic>?>((item) {
          if (item.startsWith('Flashcard:')) {
            return {
              'type': 'flashcard',
              'content': item.replaceFirst('Flashcard:', '').trim(),
            };
          } else if (item.startsWith('Question:')) {
            final parts = item.replaceFirst('Question:', '').trim().split('|');
            return {
              'type': 'question',
              'question': parts[0].trim(),
              'options': parts.sublist(1).map((e) => e.trim()).toList(),
            };
          }
          return null; // Allow null for unrecognized items
        })
        .whereType<Map<String, dynamic>>() // Filters out null values
        .toList();
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
        child: Text(
          'Error: $_errorMessage',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
    return PageView(
      children: _content.map((item) {
        switch (item['type']) {
          case 'flashcard':
            return Flashcard(content: item['content']);
          case 'question':
            return QuizQuestion(
              question: item['question'],
              options: List<String>.from(item['options']),
            );
          default:
            return const SizedBox.shrink(); // Placeholder for unsupported items
        }
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards & Quiz'),
      ),
      body: _buildContent(),
    );
  }
}
