import 'dart:async';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dio/dio.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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

  Future<void> downloadAndPrepare(String url, String examId) async {
    final hasPermission = await requestStoragePermission();
    if (!hasPermission) throw Exception("Permission denied");

    final path = await _getAudioFilePath(examId);
    final file = File(path);

    if (!await file.exists()) {
      final response = await Dio().download(url, path);
      if (response.statusCode != 200) {
        throw Exception("Download failed");
      }
    }

    await player.setFilePath(path);

    // 🔴 Wait for waveform extraction and log the result
    try {
      final extracted = await waveformController
          .extractWaveformData(
            path: path,
            noOfSamples: 400, // Increase this for more detail
          )
          .timeout(
            Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException("Waveform extraction timed out");
            },
          );
      ;
      waveformData = extracted;
      if (extracted.isEmpty) {
        throw Exception("Waveform extraction failed");
      }
      print("Waveform data extracted successfully: $waveformData");
    } catch (e) {
      print("Error extracting waveform data: $e");
    }

    await waveformController.preparePlayer(path: path);
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
    player.dispose();
    waveformController.dispose();
  }

  Future<bool> requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    }

    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    final status = await Permission.manageExternalStorage.request();
    return status.isGranted;
  }
}
