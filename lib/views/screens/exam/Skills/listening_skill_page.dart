import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prufcoach/blocs/examBloc/exam_bloc.dart';
import 'package:prufcoach/blocs/examBloc/exam_state.dart';
import 'package:prufcoach/core/routes.dart';
import 'package:prufcoach/core/utils/colors.dart';
import 'package:prufcoach/models/exam_model.dart';
import 'package:prufcoach/views/screens/exam/tale_page.dart';

class ListeningSkillPage extends StatefulWidget {
  final Exam exam;
  const ListeningSkillPage({super.key, required this.exam});

  @override
  State<ListeningSkillPage> createState() => _ListeningSkillPageState();
}

class _ListeningSkillPageState extends State<ListeningSkillPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamBloc, ExamState>(
      builder: (context, state) {
        final bloc = context.read<ExamBloc>();
        final audio = bloc.audioController;
        if (state is ExamCompleted) {
          bloc.close();
        }
        if (state is! ExamLoaded) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primaryGreen,
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(
                        audio.isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                      onPressed: () {
                        audio.isPlaying ? audio.pause() : audio.play();
                      },
                    ),
                  ),
                  Expanded(
                    child: AudioFileWaveforms(
                      size: const Size(double.infinity, 55),
                      playerController: audio.waveformController,
                      waveformType: WaveformType.fitWidth,
                      waveformData: audio.waveformData ?? [],
                      playerWaveStyle: PlayerWaveStyle(
                        fixedWaveColor: Colors.grey,
                        liveWaveColor: AppColors.primaryGreen,
                        waveThickness: 2,
                        spacing: 3,
                        showSeekLine: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SkillTalesPage(
                exam: state.exam,
                skillIndex: state.skillIndex,
                onFinished: () {
                  Navigator.pushNamed(context, AppRoutes.readingBriefing);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
