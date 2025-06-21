import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prufcoach/blocs/examBloc/exam_bloc.dart';
import 'package:prufcoach/blocs/examBloc/exam_event.dart';
import 'package:prufcoach/blocs/examBloc/exam_state.dart';

class ExamPage extends StatelessWidget {
  const ExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final parts = [_buildPart1(), _buildPart2(), _buildPart3()];

    return BlocBuilder<ExamBloc, ExamState>(
      builder: (context, state) {
        if (state is ExamLoaded) {
          final partIndex = state.partIndex;

          return Scaffold(
            appBar: AppBar(title: Text('Teil ${partIndex + 1}')),
            body: parts[partIndex],
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed:
                    partIndex < parts.length - 1
                        ? () {
                          context.read<ExamBloc>().add(NextPartRequested());
                        }
                        : null,
                child: Text(partIndex < parts.length - 1 ? 'Weiter' : 'Fertig'),
              ),
            ),
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

  Widget _buildPart1() => const Center(child: Text("Hören & Lesen"));
  Widget _buildPart2() => const Center(child: Text("Schreiben"));
  Widget _buildPart3() => const Center(child: Text("Sprechen"));
}
