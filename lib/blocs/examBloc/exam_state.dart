import 'package:prufcoach/models/exam_model.dart';

abstract class ExamState {}

class ExamInitial extends ExamState {}

class ExamLoading extends ExamState {}

class ExamLoaded extends ExamState {
  final Exam exam;
  final int skillIndex;
  ExamLoaded(this.exam, {required this.skillIndex});
}

class ExamError extends ExamState {
  final String message;
  ExamError(this.message);
}

class ExamAbandoned extends ExamState {}

class ExamCompleted extends ExamState {
  final Exam exam;
  ExamCompleted(this.exam);
}
