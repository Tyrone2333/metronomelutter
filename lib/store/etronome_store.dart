import 'package:metronomelutter/config/config.dart';
import 'package:metronomelutter/global_data.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'etronome_store.g.dart';

// This is the class used by rest of your codebase
class MetronomeStore = _MetronomeStore with _$MetronomeStore;

// The store-class
abstract class _MetronomeStore with Store {
  @observable
  int soundType = 0;

  // 拍号相关
  // 每小节 4 拍
  @observable
  int beat = Config.BEAT_DEFAULT;

  // 单位拍,以四分音符为一拍
  @observable
  int note = Config.NOTE_DEFAULT;

  @action
  void setSoundType(payload) {
    soundType = payload;
    GlobalData.sp.putInt('soundType', payload);
  }

  @action
  void setBeat(payload) {
    if (payload < Config.BEAT_MIN) {
      beat = Config.BEAT_MIN;
    } else if (payload > Config.BEAT_MAX) {
      beat = Config.BEAT_MAX;
    } else {
      beat = payload;
    }
    GlobalData.sp.putInt('beat', payload);
  }

  @action
  void noteIncrease() {
    if (note < Config.NOTE_MAX) {
      note = note * 2;
    }

    GlobalData.sp.putInt('note', note);
  }

  @action
  void noteDecrease() {
    if (note > Config.NOTE_MIN) {
      note = note ~/ 2;
    }

    GlobalData.sp.putInt('note', note);
  }
}
