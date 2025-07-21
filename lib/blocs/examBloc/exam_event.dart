abstract class ExamEvent {}

class LoadExamById extends ExamEvent {
  final int examId;
  LoadExamById(this.examId);
}

class NextPartRequested extends ExamEvent {
  NextPartRequested();
}

class BriefingRequested extends ExamEvent {
  final int briefingIndex;
  BriefingRequested(this.briefingIndex);
}

class AbandonExam extends ExamEvent {}
