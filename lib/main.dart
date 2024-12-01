import 'package:flutter/material.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/upload_page.dart';
import 'pages/flashcard_page.dart';
import 'pages/api_key_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter EdTech App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: InitialPage(), // Dynamically decide the first page
      routes: {
        '/api_key': (context) => ApiKeyPage(),
        '/upload': (context) => UploadPage(),
        '/flashcards': (context) => FlashcardPage(),
      },
    );
  }
}

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkApiKey();
  }

  Future<void> _checkApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString('api_key');

    // Navigate to the appropriate page based on API key presence
    final targetPage = apiKey == null || apiKey.isEmpty ? '/api_key' : '/upload';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed(targetPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator() // Display a loader while checking the API key
            : const SizedBox.shrink(),
      ),
    );
  }
}
