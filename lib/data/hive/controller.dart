import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:prufcoach/data/hive/user_answer.dart';

class HiveAnswerController {
  static const String boxName = 'userAnswers';

  Future<void> saveAnswer({
    required String examId,
    required String skillId,
    required String taleId,
    required List<List<int>> answers,
  }) async {
    final box = await Hive.openBox<UserAnswers>(boxName);
    final existing = box.get(examId);

    final updated = existing ?? UserAnswers(examId: examId, answers: {});

    updated.answers[skillId] ??= {};
    updated.answers[skillId]![taleId] = answers;

    await box.put(examId, updated);
  }

  Future<UserAnswers?> getAnswers(String examId) async {
    final box = await Hive.openBox<UserAnswers>(boxName);
    return box.get(examId);
  }

  Future<void> printAnswers(String examId) async {
    final data = await getAnswers(examId);
    log('🧠 Saved Answers for $examId:\n${data?.answers}');
  }
}
