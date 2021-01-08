import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class GameAudio {
  List<AudioCache> audioCaches = [];

  List files;
  int maxPlayers;

  GameAudio(this.maxPlayers, {this.files});

  Future init() async {
    for (int i = 0; i < maxPlayers; i++) {
      audioCaches.add(await _createNewAudioCache());
    }
  }

  Future play(String file, {volume = 1.0}) async {
    for (int i = 0; i < maxPlayers; i++) {
      if (audioCaches[i].fixedPlayer.state == AudioPlayerState.PLAYING) {
        audioCaches[i].fixedPlayer.stop();
      }
      return audioCaches[i].play(file, volume: volume, mode: PlayerMode.LOW_LATENCY);
    }
  }

  Future stop() async {
    for (int i = 0; i < maxPlayers; i++) {
      // if (audioCaches[i].fixedPlayer.state == AudioPlayerState.PLAYING) {
      audioCaches[i].fixedPlayer.stop();
      // }
    }
  }

  Future _createNewAudioCache() async {
    final AudioCache audioCache = AudioCache(
        // prefix: 'audio/',
        fixedPlayer: AudioPlayer());
    await audioCache.fixedPlayer.setReleaseMode(ReleaseMode.STOP);
    // await audioCache.loadAll(files);
    return audioCache;
  }

  /// Clears all the audios in the cache
  void clearAll() {
    audioCaches.forEach((audioCache) {
      audioCache.clearCache();
    });
  }

  /// Disables audio related logs
  void disableLog() {
    audioCaches.forEach((audioCache) {
      audioCache.disableLog();
    });
  }
}
