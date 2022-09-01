import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:metronomelutter/component/change_sound.dart';
import 'package:metronomelutter/component/game_audio.dart';
import 'package:metronomelutter/config/config.dart';
import 'package:metronomelutter/store/index.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:wakelock/wakelock.dart';

import './setting.dart';
import '../component/indactor.dart';
import '../component/slider.dart';
import '../component/stepper.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _nowStep = -1;
  int count = 0;
  bool _isRunning = false;
  Timer timer;
  AnimationController _animationController;

  // ios 用,防止内存泄漏 todo iOS 也要三个播放器
  GameAudio myAudio = GameAudio(1);

  // Android 用
  // 用一个播放器会导致高 BPM 的时候节奏不均匀, 因为音频是有时长的, 上一个音频还没有播放完毕就开始播放下一个, 就会导致这种节奏不均匀的问题
  // 两个用于播放 soundType2,另外一个用于 soundType1
  AudioCache audioCache1 = AudioCache(fixedPlayer: AudioPlayer());
  AudioCache audioCache2 = AudioCache(fixedPlayer: AudioPlayer());
  AudioCache audioCache3 = AudioCache(fixedPlayer: AudioPlayer());
  // Android 用, 存放 audioCache 返回值,用于下次播放前跳转到 0 毫秒的位置
  AudioPlayer player1 = AudioPlayer();
  AudioPlayer player2 = AudioPlayer();
  AudioPlayer player3 = AudioPlayer();

  String shortcut = "no action set";

  @override
  void initState() {
    super.initState();
    // 设定桌面图标长按 BEGIN
    final QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      setState(() {
        if (shortcutType != null) {
          shortcut = shortcutType;
          _toggleIsRunning();
        }
      });
    });
    quickActions.setShortcutItems(<ShortcutItem>[
      // NOTE: This first action icon will only work on iOS.
      // In a real world project keep the same file name for both platforms.
      const ShortcutItem(
        type: 'start',
        localizedTitle: '开始',
        icon: 'play',
      ),
      // NOTE: This second action icon will only work on Android.
      // In a real world project keep the same file name for both platforms.
      // const ShortcutItem(type: 'action_two', localizedTitle: '播放 Action two', icon: 'ic_launcher'),
    ]);
    // 设定桌面图标长按 END

    if (!kIsWeb) {
      Wakelock.enable();
    }

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    myAudio.init();
    // Timer(Duration(milliseconds: 1000), () {
    //   showBeatSetting();
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  showBeatSetting() {
    showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.surface,
        context: context,
        builder: (BuildContext bc) {
          return Observer(
            builder: (_) => Container(
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
                    Divider(
                        // color: Color(0xffcccccc),
                        ),
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
      timer.cancel();
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
      if (Platform.isIOS) {
        return myAudio.play('metronome$soundType-1.wav');
      } else {
        await player1.seek(Duration(milliseconds: 0));
        player1 = await audioCache1.play('metronome$soundType-1.wav');
        return;
      }
    } else {
      if (Platform.isIOS) {
        return myAudio.play('metronome$soundType-2.wav');
      } else {
        // 交替使用播放器
        if (count % 2 == 0) {
          await player2.seek(Duration(milliseconds: 0));
          player2 = await audioCache2.play('metronome$soundType-2.wav');
          return;
        } else {
          await player3.seek(Duration(milliseconds: 0));
          player3 = await audioCache3.play('metronome$soundType-2.wav');
          return;
        }
      }
    }
  }

  void runTimer() {
    timer = Timer(Duration(milliseconds: (60 / appStore.bpm * 1000).toInt()), () {
      count++;
      _playAudio().then((value) => _setNowStep());
      runTimer();
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
                      icon: Icon(Icons.settings),
                      color: Theme.of(context).textTheme.headline3.color,
                      onPressed: () async {
                        final result = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Setting()));
                        print('setting result: $result');
                      },
                    )
                  ],
                )),
            // Text(
            //   '节拍器',
            //   style: Theme.of(context).textTheme.headline3,
            // ),

            SliderRow(appStore.bpm, _setBpmHanlder),

            // 小点
            IndactorRow(_nowStep, appStore.beat),

            // 底部控制区
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.music_note,
                  ),
                  onPressed: () async {
                    final res = await changeSound(context);
                    if (res != null) {
                      appStore.setSoundType(res);
                    }
                  },
                  color: Theme.of(context).accentColor,
                ),

                // 开始/暂停
                IconButton(
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: _animationController,
                  ),
                  onPressed: _toggleIsRunning,
                  color: Theme.of(context).accentColor,
                ),
                // 拍号
                GestureDetector(
                  onTap: showBeatSetting,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(120),
                    child: Container(
                      color: Theme.of(context).accentColor,
                      width: 50,
                      height: 50,
                      child: Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          // overflow: TextOverflow.ellipsis,
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          text: TextSpan(
                            style: TextStyle(
                                color: Colors.white, fontSize: 16.0, height: 1),
                            children: [
                              TextSpan(text: appStore.beat.toString()),
                              TextSpan(text: '/'),
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
            SizedBox(
              height: 0,
            ),
            // TimeSignature(appStore.beat, appStore.note),
          ],
        ),
      ),
    ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
