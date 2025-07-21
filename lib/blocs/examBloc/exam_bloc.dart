import 'dart:developer';

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
      final current = state as ExamLoaded;
      final nextIndex = current.skillIndex + 1;

      if (nextIndex < current.exam.skills.length) {
        log('Moving to part $nextIndex');
        emit(ExamLoaded(current.exam, skillIndex: nextIndex));
      } else {
        // Handle exam completion logic here if needed
        emit(ExamCompleted(current.exam));
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
      emit(ExamLoaded(result.response!, skillIndex: 0));
    } else {
      emit(ExamError(result.message ?? 'Failed to load exam'));
    }
  }
}
