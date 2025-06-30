import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prufcoach/blocs/examBloc/exam_bloc.dart';
import 'package:prufcoach/blocs/examBloc/exam_event.dart';
import 'package:prufcoach/blocs/examBloc/exam_state.dart';
import 'package:prufcoach/core/utils/colors.dart';
import 'package:prufcoach/models/exam_model.dart';
import 'package:prufcoach/views/screens/exam/listeningPart/listening_skill_page.dart'; // Make sure you import your model

class ExamPage extends StatefulWidget {
  const ExamPage({super.key});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  final Duration _totalDuration = const Duration(minutes: 45);

  void _startTimer() {
    _timer?.cancel();
    _elapsed = Duration.zero;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_elapsed >= _totalDuration) {
        timer.cancel();
      } else {
        setState(() {
          _elapsed += const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final m = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamBloc, ExamState>(
      builder: (context, state) {
        if (state is ExamLoaded) {
          final partIndex = state.partIndex;
          final exam = state.exam;

          final parts = [
            _buildPart1(exam, partIndex),
            _buildPart2(exam, partIndex),
            _buildPart3(exam, partIndex),
            _buildPart4(exam, partIndex),
          ];

          return Scaffold(
            backgroundColor: AppColors.lightBackground,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        exam.skills[partIndex].name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.read<ExamBloc>().add(AbandonExam());
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: const Text(
                            "Prüfung Beenden",
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Zeit verbleibend:"),
                          Text(_formatDuration(_totalDuration - _elapsed)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: _elapsed.inSeconds / _totalDuration.inSeconds,
                        backgroundColor: Colors.grey[300],
                        minHeight: 20,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.redAccent,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                  Expanded(child: parts[partIndex]),
                ],
              ),
            ),
            // bottomNavigationBar: Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: ElevatedButton(
            //     onPressed:
            //         partIndex < parts.length - 1
            //             ? () {
            //               context.read<ExamBloc>().add(NextPartRequested());
            //             }
            //             : null,
            //     child: Text(partIndex < parts.length - 1 ? 'Weiter' : 'Fertig'),
            //   ),
            // ),
          );
        } else if (state is ExamLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ExamError) {
          return Center(child: Text('Fehler: ${state.message}'));
        }

        return const Scaffold(
          body: Center(child: Text('Keine Prüfung geladen')),
        );
      },
    );
  }

  // ✅ Each part now receives the exam and partIndex
  Widget _buildPart1(Exam exam, int partIndex) =>
      ListeningSkillPage(skill: exam.skills[0]);

  Widget _buildPart2(Exam exam, int partIndex) {
    final skill = exam.skills[partIndex];
    return Center(child: Text("Teil 2: ${skill.name}"));
  }

  Widget _buildPart3(Exam exam, int partIndex) {
    final skill = exam.skills[partIndex];
    return Center(child: Text("Teil 3: ${skill.name}"));
  }

  Widget _buildPart4(Exam exam, int partIndex) {
    final skill = exam.skills[partIndex];
    return Center(child: Text("Teil 4: ${skill.name}"));
  }
}
