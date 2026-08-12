import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:metronome/component/change_sound.dart';
import 'package:metronome/component/game_audio.dart';
import 'package:metronome/config/config.dart';
import 'package:metronome/store/index.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import './setting.dart';
import '../component/indactor.dart';
import '../component/slider.dart';
import '../component/stepper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _nowStep = -1;
  int count = 0;
  bool _isRunning = false;
  Timer? timer;
  late AnimationController _animationController;

  // 用于漂移补偿的绝对时间基准
  final Stopwatch _stopwatch = Stopwatch();
  // 下一拍相对于 _stopwatch 起点的目标时刻(毫秒,保留小数)
  double _nextBeatMs = 0;

  // 音频播放器池,iOS/Android 通用。多个播放器轮流使用,避免高 BPM 时声音相互打断
  final GameAudio myAudio = GameAudio(4);

  String shortcut = "no action set";

  @override
  void initState() {
    super.initState();
    // 设定桌面图标长按 BEGIN
    const QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      setState(() {
        shortcut = shortcutType;
        _toggleIsRunning();
      });
    });
    quickActions.setShortcutItems(<ShortcutItem>[
      // NOTE: This first action icon will only work on iOS.
      const ShortcutItem(
        type: 'start',
        localizedTitle: '开始',
        icon: 'play',
      ),
    ]);
    // 设定桌面图标长按 END

    if (!kIsWeb) {
      WakelockPlus.enable();
    }

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    myAudio.init();
  }

  @override
  void dispose() {
    timer?.cancel();
    _stopwatch.stop();
    myAudio.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void showBeatSetting() {
    showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.surface,
        context: context,
        builder: (BuildContext bc) {
          return Observer(
            builder: (_) => SizedBox(
              // 2排 高度 + 分割线高度
              height: (63 * 2 + 16).toDouble(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SyStepper(
                      value: appStore.beat,
                      step: 1,
                      iconSize: 24,
                      textSize: 36,
                      min: Config.BEAT_MIN,
                      max: Config.BEAT_MAX,
                      onChange: (b) {
                        appStore.setBeat(b);
                      },
                    ),
                    const Divider(),
                    SyStepper(
                      value: appStore.note,
                      step: 1,
                      iconSize: 24,
                      textSize: 36,
                      min: Config.NOTE_MIN,
                      max: Config.NOTE_MAX,
                      manualControl: (type, nowValue) {
                        if (type == StepperEventType.increase) {
                          appStore.noteIncrease();
                        } else {
                          appStore.noteDecrease();
                        }
                      },
                      // 无用,为了能正常显示 不可用状态
                      onChange: (i) {},
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _setBpmHanlder(int val) {
    appStore.setBpm(val);
  }

  void _toggleIsRunning() {
    if (_isRunning) {
      timer?.cancel();
      _stopwatch.stop();
      _animationController.reverse();
      myAudio.stop();
    } else {
      runTimer();
      _animationController.forward();
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _setNowStep() {
    setState(() {
      _nowStep++;
    });
  }

  Future<void> _playAudio() async {
    int nextStep = _nowStep + 1;
    int soundType = appStore.soundType;
    if (nextStep % appStore.beat == 0) {
      // 重音拍
      return myAudio.play('metronome$soundType-1.wav');
    } else {
      return myAudio.play('metronome$soundType-2.wav');
    }
  }

  void runTimer() {
    // 以绝对时间轴为基准,避免定时器误差累积
    _stopwatch
      ..reset()
      ..start();
    _nextBeatMs = 60 / appStore.bpm * 1000;
    _scheduleNextBeat();
  }

  void _scheduleNextBeat() {
    // 目标时刻减去真实已流逝时间 = 本次应等待的时长,以此补偿上一拍的漂移
    int delay = (_nextBeatMs - _stopwatch.elapsedMilliseconds).round();
    if (delay < 0) delay = 0;
    timer = Timer(Duration(milliseconds: delay), () {
      count++;
      // 不 await 音频,避免播放延迟阻塞下一拍的排期
      _playAudio();
      _setNowStep();
      // 用当前 bpm 累加目标时刻,支持运行中变速
      _nextBeatMs += 60 / appStore.bpm * 1000;
      _scheduleNextBeat();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Observer(
      builder: (_) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // 顶部工具栏
            Container(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.settings),
                      color: Theme.of(context).textTheme.displaySmall?.color,
                      onPressed: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Setting()));
                        debugPrint('setting result: $result');
                      },
                    )
                  ],
                )),

            SliderRow(appStore.bpm, _setBpmHanlder),

            // 小点
            IndactorRow(_nowStep, appStore.beat),

            // 底部控制区
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.music_note,
                  ),
                  onPressed: () async {
                    final res = await changeSound(context);
                    if (res != null) {
                      appStore.setSoundType(res);
                    }
                  },
                  color: Theme.of(context).colorScheme.secondary,
                ),

                // 开始/暂停
                IconButton(
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: _animationController,
                  ),
                  onPressed: _toggleIsRunning,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                // 拍号
                GestureDetector(
                  onTap: showBeatSetting,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(120),
                    child: Container(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 50,
                      height: 50,
                      child: Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          text: TextSpan(
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16.0, height: 1),
                            children: [
                              TextSpan(text: appStore.beat.toString()),
                              const TextSpan(text: '/'),
                              TextSpan(text: appStore.note.toString()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 为了让底部留出空间
            const SizedBox(
              height: 0,
            ),
          ],
        ),
      ),
    ));
  }
}
