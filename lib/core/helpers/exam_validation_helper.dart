import 'package:prufcoach/data/hive/user_answer.dart';
import 'package:prufcoach/models/exam_model.dart';

class ExamValidationHelper {
  /// Validate answers and return total score
  static double calculateExamScore(Exam exam, UserAnswers userAnswers) {
    double totalScore = 0;

    for (final skill in exam.skills) {
      final skillAnswers = userAnswers.answers[skill.id.toString()] ?? {};

      for (final story in skill.stories) {
        final taleAnswers = skillAnswers[story.id.toString()] ?? [];

        for (int qIndex = 0; qIndex < story.questions.length; qIndex++) {
          final question = story.questions[qIndex];

          // user’s answers for this question (list of choice indexes)
          final userChoiceIndexes =
              qIndex < taleAnswers.length
                  ? List<int>.from(taleAnswers[qIndex])
                  : <int>[];

          // build list of correct indexes
          final correctIndexes = <int>[];
          for (int i = 0; i < question.answers.length; i++) {
            if (question.answers[i].isCorrect) {
              correctIndexes.add(i);
            }
          }

          // compare sets → if correct, award score
          if (_isAnswerCorrect(userChoiceIndexes, correctIndexes)) {
            totalScore += question.score.toDouble();
          }
        }
      }
    }

    return totalScore;
  }

  /// Helper to check equality of answers ignoring order
  static bool _isAnswerCorrect(List<int> user, List<int> correct) {
    if (user.length != correct.length) return false;
    final userSet = user.toSet();
    final correctSet = correct.toSet();
    return userSet.containsAll(correctSet);
  }
}
