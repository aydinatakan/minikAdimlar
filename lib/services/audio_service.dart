import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  Future<void> playAsset(String assetPath) async {
    try {
      await _player.stop();
      await _player.play(AssetSource(assetPath.replaceFirst('assets/', '')));
      _isPlaying = true;
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> stop() async {
    await _player.stop();
    _isPlaying = false;
  }

  Future<void> togglePlay(String assetPath) async {
    if (_isPlaying) {
      await _player.pause();
      _isPlaying = false;
    } else {
      await playAsset(assetPath);
    }
  }

  void dispose() {
    _player.dispose();
  }
}
