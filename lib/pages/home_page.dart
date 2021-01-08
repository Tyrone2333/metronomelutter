import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:metronomelutter/component/game_audio.dart';
import 'package:metronomelutter/config/config.dart';
import 'package:metronomelutter/store/index.dart';
import 'package:metronomelutter/utils/global_function.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  int _bpm = 70;
  int _nowStep = -1;
  bool _isRunning = false;
  Timer timer;
  AnimationController _animationController;

  // ios 用,防止内存泄漏
  GameAudio myAudio = GameAudio(1);
  // Android 用
  AudioCache audioCache = AudioCache(
      // prefix: 'audio/',
      fixedPlayer: AudioPlayer());
  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      Wakelock.enable();
    }
    setBpm();
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
    setState(() {
      _bpm = val;
    });
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

  Future<void> _playAudio() {
    int nextStep = _nowStep + 1;
    int soundType = appStore.soundType;
    if (nextStep % appStore.beat == 0) {
      if (Platform.isIOS) {
        return myAudio.play('metronome$soundType-1.mp3');
      } else {
        return audioCache.play('metronome$soundType-1.mp3');
      }
    } else {
      if (Platform.isIOS) {
        return myAudio.play('metronome$soundType-2.mp3');
      } else {
        return audioCache.play('metronome$soundType-2.mp3');
      }
    }
  }

  void runTimer() {
    timer = Timer(Duration(milliseconds: (60 / _bpm * 1000).toInt()), () {
      _playAudio().then((value) => _setNowStep());
      runTimer();
    });
  }

  Future setBpm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int bpm = prefs.getInt('bpm');
    if (bpm != null) {
      print('get bpm $bpm');
      // 超过范围,重置回默认
      if (bpm < Config.BPM_MIN || bpm > Config.BPM_MAX) {
        bpm = Config.BPM_DEFAULT;
      }
      _setBpmHanlder(bpm);
    }
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
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.settings),
                      color: Theme.of(context).textTheme.headline3.color,
                      onPressed: () async {
                        final result =
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => Setting()));
                        print('setting result: $result');
                      },
                    )
                  ],
                )),
            // Text(
            //   '节拍器',
            //   style: Theme.of(context).textTheme.headline3,
            // ),

            SliderRow(_bpm, _setBpmHanlder, _isRunning, _toggleIsRunning, _animationController),

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
                  onPressed: () {
                    $warn('todo');
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
                          textScaleFactor: MediaQuery.of(context).textScaleFactor,
                          text: TextSpan(
                            style: TextStyle(color: Colors.white, fontSize: 16.0, height: 1),
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
