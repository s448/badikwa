import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:prufcoach/data/hive/user_answer.dart';
import 'package:prufcoach/models/exam_model.dart';

class ExamProgressHelper {
  static double countTotalQuestions(Exam exam) {
    return exam.skills.fold(0, (total, skill) {
      return total +
          skill.stories.fold(0, (sum, tale) {
            return sum + tale.questions.length;
          });
    });
  }

  static int countAnsweredQuestions(Box<UserAnswers> box, String examId) {
    final userAnswers = box.get(examId);

    if (userAnswers == null || userAnswers.answers.isEmpty) return 0;

    int count = 0;

    userAnswers.answers.forEach((key, answer) {
      count++;
    });

    return count;
  }

  static double calculateProgress(Box<UserAnswers> box, Exam exam) {
    final total = countTotalQuestions(exam);
    if (total == 0) return 0.0;

    final answered = countAnsweredQuestions(box, exam.id.toString());
    return answered / total;
  }

  static int calculatePercentage(Box<UserAnswers> box, Exam exam) {
    final progress = calculateProgress(box, exam);
    return (progress * 100).round();
  }

  static Color getProgressColor(double percentage) {
    if (percentage <= 0.25) {
      return Colors.red;
    } else if (percentage <= 0.5) {
      return Colors.orange;
    } else if (percentage <= 0.75) {
      return Colors.green.shade300;
    } else {
      return Colors.green.shade800; // dark green
    }
  }
}
