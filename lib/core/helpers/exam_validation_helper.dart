// lib/core/helpers/exam_validation_helper.dart
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:prufcoach/data/hive/user_answer.dart';
import 'package:prufcoach/models/exam_model.dart'; // adjust to your actual Hive UserAnswers import

/// Per question result for debugging / UI
class PerQuestionResult {
  final int skillId;
  final int storyId;
  final int questionIndex; // index inside the story.questions list
  final int questionId; // question.id from model
  final bool isCorrect;
  final int awarded; // 1 or q.score if useQuestionScore true
  final List<int> correctIndices; // indexes of correct options (0-based)
  final List<int> selectedIndices; // selected indexes after interpretation
  final List<int> rawSelectedValues; // exactly what's stored in Hive
  final bool
  interpretedAsIds; // true if rawSelected were interpreted as answer IDs

  PerQuestionResult({
    required this.skillId,
    required this.storyId,
    required this.questionIndex,
    required this.questionId,
    required this.isCorrect,
    required this.awarded,
    required this.correctIndices,
    required this.selectedIndices,
    required this.rawSelectedValues,
    required this.interpretedAsIds,
  });

  Map<String, dynamic> toJson() => {
    'skillId': skillId,
    'storyId': storyId,
    'questionIndex': questionIndex,
    'questionId': questionId,
    'isCorrect': isCorrect,
    'awarded': awarded,
    'correctIndices': correctIndices,
    'selectedIndices': selectedIndices,
    'rawSelectedValues': rawSelectedValues,
    'interpretedAsIds': interpretedAsIds,
  };
}

/// overall result
class ExamValidationResult {
  final int totalQuestions;
  final int totalAwarded;
  final double percentage;
  final List<PerQuestionResult> perQuestion;

  ExamValidationResult({
    required this.totalQuestions,
    required this.totalAwarded,
    required this.percentage,
    required this.perQuestion,
  });

  Map<String, dynamic> toJson() => {
    'totalQuestions': totalQuestions,
    'totalAwarded': totalAwarded,
    'percentage': percentage,
    'perQuestion': perQuestion.map((p) => p.toJson()).toList(),
  };
}

/// Helper that evaluates exam offline using UserAnswers stored in Hive.
///
/// Important behaviour:
/// - If selected values in Hive match answer IDs -> they are interpreted as IDs and mapped to indexes.
/// - If selected values are in range 0..(answers.length-1) -> they are treated as indexes directly.
/// - Mixed values are mapped where possible (IDs -> indices, numeric in-range kept).
/// - Exact set match between selectedIndices and correctIndices -> question correct.
/// - By default each question gives 1 point. Set useQuestionScore = true to use question.score (falls back to >=1).
class ExamValidationHelper {
  /// Evaluate exam using Hive UserAnswers.
  /// - [useQuestionScore] default false (each q = 1). Set true to use question.score.
  /// - [verbose] if true prints debug messages to console.
  static ExamValidationResult evaluateExam({
    required Exam exam,
    required UserAnswers userAnswers,
    bool useQuestionScore = false,
    bool verbose = false,
  }) {
    final List<PerQuestionResult> perQuestion = [];
    int totalQuestions = 0;
    int totalAwarded = 0;

    // Helper to attempt to get skill answers using flexible keys
    Map<String, List<List<int>>>? getSkillAnswers(dynamic skill) {
      // keys inside userAnswers.answers are strings; try common forms
      final Map<String, Map<String, List<List<int>>>> all = userAnswers.answers;

      final String idKey = skill.id.toString();
      final String nameKey = (skill.name ?? '').toString();

      if (all.containsKey(idKey)) return all[idKey];
      if (nameKey.isNotEmpty && all.containsKey(nameKey)) return all[nameKey];
      // also try numeric key as int->string (already handled), else null
      return null;
    }

    // iterate every skill -> story -> question
    for (final skill in exam.skills) {
      final skillAnswers = getSkillAnswers(skill);

      for (final story in skill.stories) {
        final storyIdKey = story.id.toString();
        final userStoryList =
            skillAnswers == null ? null : skillAnswers[storyIdKey];

        final int qCount = story.questions.length;
        for (int qIndex = 0; qIndex < qCount; qIndex++) {
          totalQuestions++;
          final question = story.questions[qIndex];

          // raw selected values saved in hive (may be indices or ids)
          final List<int> rawSelected =
              (userStoryList != null && qIndex < userStoryList.length)
                  ? List<int>.from(userStoryList[qIndex])
                  : <int>[];

          // prepare mapping info
          final List<int> answerIds =
              question.answers.map((a) => a.id).toList();
          final List<int> correctIndices = [];
          for (int i = 0; i < question.answers.length; i++) {
            if (question.answers[i].isCorrect) correctIndices.add(i);
          }

          // detect if rawSelected are IDs or indices
          final bool allInIds =
              rawSelected.isNotEmpty &&
              rawSelected.every((v) => answerIds.contains(v));
          final bool allInIndices =
              rawSelected.isNotEmpty &&
              rawSelected.every((v) => v >= 0 && v < answerIds.length);

          bool interpretedAsIds = false;
          final Set<int> selectedIndices = <int>{};

          if (rawSelected.isEmpty) {
            // unanswered -> selectedIndices empty
          } else if (allInIds && !allInIndices) {
            // treat as IDs
            interpretedAsIds = true;
            for (final id in rawSelected) {
              final idx = answerIds.indexOf(id);
              if (idx != -1) selectedIndices.add(idx);
            }
          } else if (allInIndices && !allInIds) {
            // treat as indices
            interpretedAsIds = false;
            for (final idx in rawSelected) {
              if (idx >= 0 && idx < answerIds.length) selectedIndices.add(idx);
            }
          } else {
            // mixture or ambiguous: try to map ids where possible, keep indices in range
            for (final v in rawSelected) {
              if (answerIds.contains(v)) {
                // this value is actually an answer id
                interpretedAsIds = true; // at least one id found
                final idx = answerIds.indexOf(v);
                if (idx != -1) selectedIndices.add(idx);
              } else if (v >= 0 && v < answerIds.length) {
                selectedIndices.add(v);
              } else {
                // unknown value: ignore but log if verbose
                if (verbose) {
                  debugPrint(
                    'ExamValidationHelper: unknown saved value $v for question ${question.id}',
                  );
                }
              }
            }
          }

          // compare sets - exact match required
          final List<int> selectedList = selectedIndices.toList()..sort();
          final List<int> correctList = List<int>.from(correctIndices)..sort();
          final bool isCorrect = listEquals(selectedList, correctList);

          final int awarded =
              isCorrect ? (useQuestionScore ? max(1, question.score) : 1) : 0;
          totalAwarded += awarded;

          perQuestion.add(
            PerQuestionResult(
              skillId: skill.id,
              storyId: story.id,
              questionIndex: qIndex,
              questionId: question.id,
              isCorrect: isCorrect,
              awarded: awarded,
              correctIndices: correctList,
              selectedIndices: selectedList,
              rawSelectedValues: rawSelected,
              interpretedAsIds: interpretedAsIds,
            ),
          );

          if (verbose) {
            debugPrint(
              'Q ${question.id} (skill ${skill.id} / story ${story.id} / idx $qIndex): '
              'raw=${rawSelected.toString()}, interpretedIndices=${selectedList.toString()}, '
              'correct=${correctList.toString()}, correct?=$isCorrect, awarded=$awarded',
            );
          }
        }
      }
    }

    final double percentage =
        totalQuestions == 0 ? 0.0 : (totalAwarded / totalQuestions) * 100.0;
    return ExamValidationResult(
      totalQuestions: totalQuestions,
      totalAwarded: totalAwarded,
      percentage: double.parse(percentage.toStringAsFixed(2)),
      perQuestion: perQuestion,
    );
  }
}
