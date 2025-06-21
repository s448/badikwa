import 'package:prufcoach/models/exam_model.dart';

abstract class ExamState {}

class ExamInitial extends ExamState {}

class ExamLoading extends ExamState {}

class ExamLoaded extends ExamState {
  final Exam exam;
  final int partIndex;
  ExamLoaded(this.exam, {this.partIndex = 0});
}

class ExamError extends ExamState {
  final String message;
  ExamError(this.message);
}
