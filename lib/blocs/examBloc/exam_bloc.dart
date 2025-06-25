import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prufcoach/controller/audio_controller.dart';
import 'package:prufcoach/data/exam_data.dart';
import 'exam_event.dart';
import 'exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final ExamData examData = ExamData();
  final AudioController audioController = AudioController();

  ExamBloc() : super(ExamInitial()) {
    on<LoadExamById>(_onLoadExamById);
    on<NextPartRequested>(_onNextPartRequested);
    on<AbandonExam>(_closeBloc);
  }

  Future<void> _closeBloc(AbandonExam event, Emitter<ExamState> emit) async {
    audioController.dispose();
    emit(ExamAbandoned());
    close();
  }

  // @override
  // Future<void> close() {
  //   audioController.dispose();
  //   return super.close();
  // }

  Future<void> _onNextPartRequested(
    NextPartRequested event,
    Emitter<ExamState> emit,
  ) async {
    if (state is ExamLoaded) {
      final currentState = state as ExamLoaded;
      final nextPartIndex = currentState.partIndex + 1;

      if (nextPartIndex < 3) {
        // Assuming there are 3 parts
        emit(ExamLoaded(currentState.exam, partIndex: nextPartIndex));
      } else {
        // Handle exam completion logic here if needed
        emit(ExamLoaded(currentState.exam, partIndex: nextPartIndex));
      }
    }
  }

  Future<void> _onLoadExamById(
    LoadExamById event,
    Emitter<ExamState> emit,
  ) async {
    emit(ExamLoading());

    final result = await examData.getExamById(event.examId);

    await audioController.downloadAndPrepare(
      result.response!.skills.first.audioUrl ?? "",
      result.response!.id.toString(),
    );

    if (result.success && result.response != null) {
      emit(ExamLoaded(result.response!));
    } else {
      emit(ExamError(result.message ?? 'Failed to load exam'));
    }
  }
}
