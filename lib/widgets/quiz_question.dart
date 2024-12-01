import 'package:flutter/material.dart';

class QuizQuestion extends StatelessWidget {
  final String question;
  final List<String> options;

  const QuizQuestion({super.key, required this.question, required this.options});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(question, style: const TextStyle(fontSize: 18)),
          ...options.map((option) => RadioListTile(value: option, groupValue: null, onChanged: (value) {})),
        ],
      ),
    );
  }
}
