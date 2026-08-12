import 'package:audioplayers/audioplayers.dart';

/// 节拍器音频播放器(基于 audioplayers 6.x)
///
/// 用一个播放器会导致高 BPM 时节奏不均匀,因为音频有时长,上一个还没播完就要播下一个,
/// 声音会被打断。这里维护一个播放器池,轮流使用不同的播放器,避免相互打断。
class GameAudio {
  final int maxPlayers;
  final List<AudioPlayer> _players = [];
  int _next = 0;

  GameAudio(this.maxPlayers);

  Future<void> init() async {
    for (int i = 0; i < maxPlayers; i++) {
      final player = AudioPlayer();
      await player.setReleaseMode(ReleaseMode.stop);
      // 低延迟模式,适合节拍器这类短音效
      await player.setPlayerMode(PlayerMode.lowLatency);
      _players.add(player);
    }
  }

  /// file 例如 'metronome0-1.wav',AssetSource 默认在 assets/ 目录下查找
  Future<void> play(String file, {double volume = 1.0}) async {
    if (_players.isEmpty) return;
    final player = _players[_next];
    _next = (_next + 1) % _players.length;
    await player.play(AssetSource(file), volume: volume);
  }

  Future<void> stop() async {
    for (final player in _players) {
      await player.stop();
    }
  }

  Future<void> dispose() async {
    for (final player in _players) {
      await player.dispose();
    }
    _players.clear();
  }
}
