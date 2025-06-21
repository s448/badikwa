abstract class ExamEvent {}

class LoadExamById extends ExamEvent {
  final int examId;
  LoadExamById(this.examId);
}

class NextPartRequested extends ExamEvent {
  NextPartRequested();
}
