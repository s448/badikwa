import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prufcoach/blocs/examBloc/exam_bloc.dart';
import 'package:prufcoach/blocs/examBloc/exam_event.dart';
import 'package:prufcoach/blocs/examBloc/exam_state.dart';
import 'package:prufcoach/models/exam_model.dart';
import 'package:prufcoach/views/screens/exam/Skills/briefingPages/exam_ending_page.dart';
import 'package:prufcoach/views/screens/exam/tale_page.dart';

class WritingSkillPage extends StatelessWidget {
  final Exam exam;

  const WritingSkillPage({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExamBloc, ExamState>(
      listener: (context, state) {
        if (state is ExamAbandoned) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ExamEndingPage()),
          );
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: buildDescriptionAsHTML(
                context,
                exam.skills[2].description ?? "",
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 5, right: 5, top: 2),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.red,
              padding: const EdgeInsets.all(16),
            ),
            onPressed: () {
              context.read<ExamBloc>().add(AbandonExam());
            },
            child: Text(
              'Weiter zum Teil Schreiben',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
