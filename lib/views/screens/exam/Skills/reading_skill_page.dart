import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prufcoach/blocs/examBloc/exam_bloc.dart';
import 'package:prufcoach/blocs/examBloc/exam_event.dart';
import 'package:prufcoach/blocs/examBloc/exam_state.dart';
import 'package:prufcoach/models/exam_model.dart';
import 'package:prufcoach/views/screens/exam/tale_page.dart';

class ReadingSkillPage extends StatelessWidget {
  final Exam exam;

  const ReadingSkillPage({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        BlocBuilder<ExamBloc, ExamState>(
          builder: (context, state) {
            if (state is ExamLoaded) {
              return Expanded(
                child: SkillTalesPage(
                  exam: exam,
                  skillIndex: state.partIndex,
                  onFinished: () {
                    // Move to next skill when done
                    context.read<ExamBloc>().add(NextPartRequested());
                  },
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }
}
