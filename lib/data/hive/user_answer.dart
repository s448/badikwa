import 'package:hive/hive.dart';

part 'user_answer.g.dart';

@HiveType(typeId: 0)
class UserAnswers extends HiveObject {
  @HiveField(0)
  final String examId;

  /// Structure:
  /// skillId → taleId → list of answer indexes per question
  /// e.g., { "skill1": { "tale1": [[0], [1, 2]] } }
  @HiveField(1)
  Map<String, Map<String, List<List<int>>>> answers;

  UserAnswers({required this.examId, required this.answers});
}
