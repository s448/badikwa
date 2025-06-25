import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prufcoach/blocs/examBloc/exam_bloc.dart';
import 'package:prufcoach/blocs/examBloc/exam_state.dart';
import 'package:prufcoach/core/utils/colors.dart';
import 'package:prufcoach/models/exam_model.dart';

class ListeningSkillPage extends StatefulWidget {
  final Skill skill;
  const ListeningSkillPage({super.key, required this.skill});

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
    return Column(
      children: [
        const SizedBox(height: 20),
        BlocBuilder<ExamBloc, ExamState>(
          builder: (context, state) {
            final bloc = context.read<ExamBloc>();
            final audio = bloc.audioController;
            if (state is ExamAbandoned) {
              bloc.close();
            }
            if (state is ExamLoaded) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primaryGreen,
                      child: IconButton(
                        // iconSize: 38,
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
                        size: const Size(
                          double.infinity,
                          55,
                        ), // OK inside Expanded
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
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 20),
        Text(
          widget.skill.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: 10, // Example count
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Listening Part ${index + 1}'),
                onTap: () {
                  // Handle part selection
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
