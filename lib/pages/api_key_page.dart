import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiKeyPage extends StatefulWidget {
  const ApiKeyPage({super.key});

  @override
  _ApiKeyPageState createState() => _ApiKeyPageState();
}

class _ApiKeyPageState extends State<ApiKeyPage> {
  final TextEditingController _apiKeyController = TextEditingController();

  Future<void> _saveApiKey() async {
    // Save the API key to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_key', _apiKeyController.text);

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('API Key Saved')));

    // Navigate to the '/upload' page
    Navigator.pushReplacementNamed(context, '/upload');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter API Key')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(labelText: 'OpenAI API Key'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveApiKey,
              child: const Text('Save Key'),
            ),
          ],
        ),
      ),
    );
  }
}
