import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prufcoach/blocs/examBloc/exam_bloc.dart';
import 'package:prufcoach/blocs/examBloc/exam_event.dart';
import 'package:prufcoach/blocs/examBloc/exam_state.dart';
import 'package:prufcoach/core/utils/colors.dart';
import 'package:prufcoach/views/screens/exam/exam_page.dart';

class ReadingBriefingPage extends StatelessWidget {
  final int briefingIndex;

  const ReadingBriefingPage({super.key, required this.briefingIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
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
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Image.asset(
                "assets/illusts/briefing1.png",
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentYellow,
            padding: const EdgeInsets.symmetric(vertical: 22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onPressed: () {
            context.read<ExamBloc>().add(NextPartRequested());
          },
          child: Text(
            "Weiter",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
