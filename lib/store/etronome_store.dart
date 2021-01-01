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

  @action
  void setSoundType(payload) {
    soundType = payload;
    GlobalData.sp.putInt('soundType', payload);
  }
}
