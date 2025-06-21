import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prufcoach/data/exam_data.dart';
import 'exam_event.dart';
import 'exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final ExamData examData;

  ExamBloc(this.examData) : super(ExamInitial()) {
    on<LoadExamById>(_onLoadExamById);
  }

  Future<void> _onLoadExamById(
    LoadExamById event,
    Emitter<ExamState> emit,
  ) async {
    emit(ExamLoading());

    final result = await examData.getExamById(event.examId);

    if (result.success && result.response != null) {
      emit(ExamLoaded(result.response!));
    } else {
      emit(ExamError(result.message ?? 'Failed to load exam'));
    }
  }
}
