import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String?> _getApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('api_key');
  }

  Future<Map<String, dynamic>?> sendPdfContent(String content) async {
    final apiKey = await _getApiKey();

    if (apiKey == null) {
      throw Exception('API key is not set.');
    }

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "system", "content": "You are a helpful assistant."},
          {"role": "user", "content": content}
        ],
        "max_tokens": 500,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch response: ${response.body}');
    }
  }

  Future<List<String>> extractFlashcardsAndQuestions(String pdfText) async {
    final result = await sendPdfContent(
      "Analyze this text and create flashcards and quiz questions:\n$pdfText",
    );

    if (result != null && result.containsKey('choices')) {
      final content = result['choices'][0]['message']['content'];
      return content.split('\n\n').map((e) => e.trim()).toList();
    }

    return [];
  }
}
