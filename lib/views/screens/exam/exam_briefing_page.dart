import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prufcoach/blocs/examBloc/exam_bloc.dart';
import 'package:prufcoach/blocs/examBloc/exam_event.dart';
import 'package:prufcoach/blocs/examBloc/exam_state.dart';
import 'package:prufcoach/core/utils/app_messages.dart';
import 'package:prufcoach/core/utils/colors.dart';
import 'package:prufcoach/views/widgets/buttons.dart';

class ReadyPage extends StatelessWidget {
  final int examId;

  const ReadyPage({super.key, required this.examId});

  @override
  Widget build(BuildContext context) {
    // You can fetch the exam from a list by ID here
    context.read<ExamBloc>().add(LoadExamById(examId)); // Only once

    return Scaffold(
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
              BlocBuilder<ExamBloc, ExamState>(
                builder: (context, state) {
                  if (state is ExamLoading) {
                    return const Center(
                      child: CupertinoActivityIndicator(
                        color: AppColors.primaryGreen,
                        animating: true,
                        radius: 20,
                      ),
                    );
                  } else if (state is ExamLoaded) {
                    return Text(
                      'in die ${state.exam.level} Prüfung für Zuwandere',
                      style: const TextStyle(fontSize: 15),
                    );
                  }
                  return const SizedBox.shrink();
                },
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
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '''Die Prüfung besteht aus drei Teilen:
Hören & Lesen | 45 Minuten | max. 45 Punkte
Du hörst Gespräche und liest Texte.

Schreiben | 30 Minuten | max. 20 Punkte
Du schreibst eine E-Mail oder einen kurzen Text.

Sprechen | ca. 16 Minuten | max. 100 Punkte
Du stellst dich vor, sprichst mit einem Partner und gibst deine Meinung.

Um zu bestehen, musst du in jedem Teil mindestens die Hälfte der Punkte erreichen.
Trainiere realistisch – wie in der echten Prüfung!

Wenn du bereit bist, tippe auf „Prüfung starten“.''',
                  style: TextStyle(fontSize: 10, height: 1.5),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<ExamBloc, ExamState>(
                builder: (context, state) {
                  return PrimaryButton(
                    onTap:
                        (state is ExamLoaded)
                            ? () {
                              Navigator.pushReplacementNamed(context, '/exam');
                            }
                            : () {
                              appMessageShower(
                                context,
                                'Fehler',
                                'Die Prüfung konnte nicht geladen werden.',
                              );
                            },
                    child:
                        state is ExamLoaded
                            ? const Text('Prüfung starten')
                            : const Text('Lade...'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
