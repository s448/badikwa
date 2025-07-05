import 'package:hive/hive.dart';
import 'package:prufcoach/data/hive/model.dart';

class HiveController {
  static const _boxName = 'answersBox';

  /// Save user answers with key format: ExamId_TaleId_Index
  Future<void> saveAnswer({
    required String examId,
    required String taleId,
    required int index,
    required Map<int, int> selectedAnswers,
  }) async {
    final box = Hive.box<UserAnswer>(_boxName);
    final key = _buildKey(examId, taleId, index);
    final answer = UserAnswer(key: key, selectedAnswers: selectedAnswers);
    await box.put(key, answer);
  }

  /// Get saved answer by key
  UserAnswer? getAnswer(String examId, String taleId, int index) {
    final box = Hive.box<UserAnswer>(_boxName);
    final key = _buildKey(examId, taleId, index);
    return box.get(key);
  }

  /// Check if an answer exists
  bool hasAnswer(String examId, String taleId, int index) {
    final box = Hive.box<UserAnswer>(_boxName);
    final key = _buildKey(examId, taleId, index);
    return box.containsKey(key);
  }

  /// Delete a specific answer
  Future<void> deleteAnswer(String examId, String taleId, int index) async {
    final box = Hive.box<UserAnswer>(_boxName);
    final key = _buildKey(examId, taleId, index);
    await box.delete(key);
  }

  /// Clear all answers
  Future<void> clearAllAnswers() async {
    final box = Hive.box<UserAnswer>(_boxName);
    await box.clear();
  }

  /// Private helper
  String _buildKey(String examId, String taleId, int index) {
    return "${examId}_$taleId\_$index";
  }
}
