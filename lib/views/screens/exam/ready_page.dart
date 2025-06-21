import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prufcoach/blocs/examBloc/exam_bloc.dart';
import 'package:prufcoach/blocs/examBloc/exam_event.dart';
import 'package:prufcoach/blocs/examBloc/exam_state.dart';
import 'package:prufcoach/data/exam_data.dart';
import 'package:prufcoach/views/widgets/buttons.dart';

class ReadyPage extends StatelessWidget {
  final int examId;

  const ReadyPage({super.key, required this.examId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExamBloc(ExamData())..add(LoadExamById(examId)),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Herzlich Willkommen!',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'in die B1 Prüfung für Zuwandere',
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 16),
                Image.asset(
                  'assets/illusts/ready.png',
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Informationen zum Test',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                BlocBuilder<ExamBloc, ExamState>(
                  builder: (context, state) {
                    if (state is ExamLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is ExamError) {
                      return Text(state.message);
                    } else if (state is ExamLoaded) {
                      return Column(
                        children: [
                          Text(
                            'Prüfung: ${state.exam.title}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Erstellt am: ${state.exam.createdAt}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Anzahl der Skills: ${state.exam.skills.length}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PrimaryButton(
                    child: const Text('Prüfung starten'),
                    onTap: () {
                      Navigator.pushNamed(context, '/exam');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        // bottomNavigationBar: Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: PrimaryButton(
        //     child: const Text('Prüfung starten'),
        //     onTap: () {
        //       Navigator.pushNamed(context, '/exam');
        //     },
        //   ),
        // ),
      ),
    );
  }
}
