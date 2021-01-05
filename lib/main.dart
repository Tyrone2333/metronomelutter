import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:metronomelutter/global_data.dart';
import 'package:metronomelutter/pages/home_page.dart';
import 'package:metronomelutter/store/index.dart';

import 'utils/shared_preferences.dart';

void main() async {
  // 确保初始化,否则访问 SharedPreferences 会报错
  WidgetsFlutterBinding.ensureInitialized();

  GlobalData.sp = await SpUtil.getInstance();
  initSoundType();

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
      home: MyHomePage(),
    );
  }
}

initSoundType() {
  int soundType = GlobalData.sp.getInt('soundType');
  if (soundType != null) {
    print('get sound type $soundType');
    appStore.setSoundType(soundType);
  }
}
