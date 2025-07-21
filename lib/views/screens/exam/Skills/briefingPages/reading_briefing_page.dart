import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prufcoach/blocs/examBloc/exam_bloc.dart';
import 'package:prufcoach/blocs/examBloc/exam_event.dart';
import 'package:prufcoach/blocs/examBloc/exam_state.dart';
import 'package:prufcoach/views/screens/exam/exam_page.dart';

class ReadingBriefingPage extends StatelessWidget {
  final int briefingIndex;

  const ReadingBriefingPage({super.key, required this.briefingIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ExamBloc, ExamState>(
        listener: (context, state) {
          if (state is ExamLoaded) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => ExamPage()),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    "This is the briefing for skill $briefingIndex. "
                    "Here you will find important information about the skill and what to expect.",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  context.read<ExamBloc>().add(NextPartRequested());
                },
                child: Text("Start Reading Skill"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
