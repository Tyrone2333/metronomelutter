import 'package:flutter/material.dart';
import './component/slider.dart';
import './component/indactor.dart';
import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import './component/summerscar.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/foundation.dart';
import './component/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '节拍器',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: '节拍器'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _bpm = 70;
  int _nowStep = -1;
  bool _isRunning = false;
  Timer timer;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  AnimationController _animationController;
  int soundType = 0;

  void _setBpmHanlder(int val) {
    setState(() {
      _bpm = val;
    });
  }

  void _toggleIsRunning() {
    if (_isRunning) {
      timer.cancel();
      _animationController.reverse();
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
    if (nextStep % 4 == 0) {
      return assetsAudioPlayer.open(Audio('assets/metronome$soundType-1.mp3'));
    } else {
      return assetsAudioPlayer.open(Audio('assets/metronome$soundType-2.mp3'));
    }
  }

  void runTimer() {
    timer = Timer(Duration(milliseconds: (60 / _bpm * 1000).toInt()), () {
      _playAudio().then((value) => _setNowStep());
      runTimer();
    });
  }

  Future setBpm () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int bpm = prefs.getInt('bpm');
    if (bpm != null) {
      print('get bpm $bpm');
      _setBpmHanlder(bpm);
    }
  }

  Future setSoundType () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int soundType = prefs.getInt('sound');
    if (soundType != null) {
      print('get sound type $soundType');
      this.soundType = soundType;
    }
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      Wakelock.enable();
    }
    setSoundType();
    setBpm();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.settings),
                  color: Theme.of(context).textTheme.headline3.color,
                  onPressed: () async {
                    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => Setting()));
                    print('setting result: $result');
                    setSoundType();
                  },
                )
              ],
            )
          ),
          Text(
            '节拍器',
            style: Theme.of(context).textTheme.headline3,
          ),
          SliderRow(_bpm, _setBpmHanlder, _isRunning, _toggleIsRunning,
              _animationController),
          IndactorRow(_nowStep),
          Summerscar(),
        ],
      ),
    ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
