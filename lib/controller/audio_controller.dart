// lib/controller/audio_controller.dart
import 'dart:io';
import 'dart:math';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dio/dio.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:path_provider/path_provider.dart';

class AudioController {
  final just_audio.AudioPlayer player = just_audio.AudioPlayer();
  final PlayerController waveformController = PlayerController();

  List<double>? waveformData;

  Future<String> _getAudioFilePath(String examId) async {
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/prufcoach');
    if (!await folder.exists()) await folder.create(recursive: true);
    return '${folder.path}/$examId.mp3';
  }

  /// Download audio to app-private directory and prepare player.
  /// DOES NOT request any OS storage permissions.
  Future<void> downloadAndPrepare(String url, String examId) async {
    final path = await _getAudioFilePath(examId);
    final file = File(path);

    if (url.isNotEmpty && !await file.exists()) {
      try {
        final response = await Dio().download(url, path);
        if (response.statusCode != 200 && response.statusCode != 201) {
          throw Exception("Download failed: ${response.statusCode}");
        }
      } catch (e) {
        // Remove partial file if any
        if (await file.exists()) {
          try {
            await file.delete();
          } catch (_) {}
        }
        rethrow;
      }
    }

    if (await file.exists()) {
      await player.setFilePath(path);
      try {
        await waveformController.preparePlayer(path: path);
      } catch (_) {
        // waveform controller prepare may fail on some devices — ignore
      }
    } else {
      // no real file, ensure player is not in invalid state
      try {
        await player.stop();
      } catch (_) {}
    }

    // Dummy waveform for UI — stable, not blocking
    final rnd = Random(12345);
    waveformData = List.generate(400, (_) => 0.25 + rnd.nextDouble() * 0.75);
  }

  Stream<Duration> get positionStream => player.positionStream;
  Stream<just_audio.PlayerState> get playerStateStream =>
      player.playerStateStream;
  Duration? get duration => player.duration;
  bool get isPlaying => player.playing;

  void play() {
    player.play();
    waveformController.startPlayer();
  }

  void pause() {
    player.pause();
    waveformController.pausePlayer();
  }

  void dispose() {
    try {
      player.dispose();
    } catch (_) {}
    try {
      waveformController.dispose();
    } catch (_) {}
  }
}
