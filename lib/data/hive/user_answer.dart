import 'package:hive/hive.dart';

part 'user_answer.g.dart'; // This tells build_runner where to output generated code

@HiveType(typeId: 0)
class UserAnswer extends HiveObject {
  @HiveField(0)
  final String key; // Format: ExamId_TaleId_0

  @HiveField(1)
  final Map<int, int> selectedAnswers; // questionIndex -> selectedOptionIndex

  UserAnswer({required this.key, required this.selectedAnswers});
}
