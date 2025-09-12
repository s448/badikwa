// lib/blocs/examBloc/exam_bloc.dart
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prufcoach/controller/audio_controller.dart';
import 'package:prufcoach/core/helpers/exam_validation_helper.dart';
import 'package:prufcoach/data/exam_data.dart';
import 'package:prufcoach/data/hive/controller.dart';
import 'exam_event.dart';
import 'exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final ExamData examData = ExamData();
  final AudioController audioController = AudioController();

  int? _loadingExamId;

  ExamBloc() : super(ExamInitial()) {
    on<LoadExamById>(_onLoadExamById);
    on<NextPartRequested>(_onNextPartRequested);
    on<FinishExam>(_finishExam);
  }

  Future<void> _finishExam(FinishExam event, Emitter<ExamState> emit) async {
    if (state is! ExamLoaded) return;
    final current = state as ExamLoaded;
    final answerSheet = await HiveAnswerController().getAnswers(
      current.exam.id.toString(),
    );

    final score = ExamValidationHelper.calculateExamScore(
      current.exam,
      answerSheet!,
    );

    log("Exam finished with score: $score");

    audioController.dispose();
    emit(ExamCompleted(score));
  }

  Future<void> _onNextPartRequested(
    NextPartRequested event,
    Emitter<ExamState> emit,
  ) async {
    if (state is ExamLoaded) {
      final current = state as ExamLoaded;
      final nextIndex = current.skillIndex + 1;

      if (nextIndex < current.exam.skills.length) {
        emit(ExamLoaded(current.exam, skillIndex: nextIndex));
      } else {
        // reached end, allow UI to trigger FinishExam
        log('Reached end of skills.');
      }
    }
  }

  Future<void> _onLoadExamById(
    LoadExamById event,
    Emitter<ExamState> emit,
  ) async {
    if (_loadingExamId == event.examId) {
      log('Load for exam ${event.examId} already in progress, skipping.');
      return;
    }

    if (state is ExamLoaded && (state as ExamLoaded).exam.id == event.examId) {
      log('Exam ${event.examId} already loaded, skipping.');
      return;
    }

    _loadingExamId = event.examId;
    emit(ExamLoading());

    try {
      final result = await examData.getExamById(event.examId);

      if (result.success && result.response != null) {
        // prepare audio but do not let audio failure block the exam load
        try {
          final audioUrl =
              (result.response!.skills.isNotEmpty)
                  ? (result.response!.skills.first.audioUrl ?? "")
                  : "";
          await audioController.downloadAndPrepare(
            audioUrl,
            result.response!.id.toString(),
          );
        } catch (e) {
          log('Audio preparation failed but continuing: $e');
        }

        emit(ExamLoaded(result.response!, skillIndex: 0));
      } else {
        emit(ExamError(result.message ?? 'Failed to load exam'));
      }
    } catch (e, st) {
      log('Exam loading error: $e\n$st');
      emit(ExamError(e.toString()));
    } finally {
      _loadingExamId = null;
    }
  }
}
