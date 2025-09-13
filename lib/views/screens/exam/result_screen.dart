import 'package:flutter/material.dart';
import 'package:prufcoach/core/helpers/exam_validation_helper.dart';

class ExamResultPage extends StatelessWidget {
  final ExamValidationResult result;

  const ExamResultPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exam Results")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your Score: ${result.totalAwarded}/${result.totalQuestions}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "Accuracy: ${result.percentage.toStringAsFixed(1)}%",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}
