import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:metronome/global_data.dart';
import 'package:metronome/pages/home_page.dart';
import 'package:metronome/store/index.dart';

import 'utils/shared_preferences.dart';

void main() async {
  // 确保初始化,否则访问 SharedPreferences 会报错
  WidgetsFlutterBinding.ensureInitialized();

  GlobalData.sp = await SpUtil.getInstance();
  initSoundType();
  initBpm();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '节拍器',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)
            .copyWith(secondary: Colors.blue),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.grey.shade50,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(134, 165, 255, 1),
          brightness: Brightness.dark,
        ).copyWith(secondary: const Color.fromRGBO(134, 165, 255, 1)),
      ),
      themeMode: ThemeMode.system,
      home: MyHomePage(),
      builder: EasyLoading.init(),
    );
  }
}

void initSoundType() {
  int? soundType = GlobalData.sp.getInt('soundType');
  if (soundType != null) {
    appStore.setSoundType(soundType);
  }
}

void initBpm() {
  int? spRes = GlobalData.sp.getInt('bpm');
  if (spRes != null) {
    appStore.setBpm(spRes);
  }
}
