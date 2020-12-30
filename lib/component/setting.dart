import 'package:flutter/material.dart';
import 'package:metronomelutter/utils/global_function.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('设置')),
      body: Container(
        child: Column(
          children: [
            buildInkWellSettingItem(
              '音效',
              context,
              onTap: () async {
                final res = await changeSound(context);
                if (res != null) {
                  _setSoundType(res);
                }
              },
            ),
            // 节拍
            buildInkWellSettingItem(
              '源码',
              context,
              onTap: () async {
                launchURL('https://github.com/Tyrone2333/metronomelutter');
              },
            ),
            // 节拍
            buildInkWellSettingItem(
              '关于',
              context,
              onTap: () async {
                $confirm(
                  '基于 flutter 技术打造的全平台节拍器', context,
                  // customBody: Text('222'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  buildInkWellSettingItem(
    String text,
    BuildContext context, {
    final Function onTap,
  }) {
    return InkWell(
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Text(
          text,
          style: Theme.of(context).textTheme.button,
        ),
      ),
      onTap: onTap,
    );
  }
}

Future<int> changeSound(context) async {
  int i = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('请选择音效'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                // 返回1
                Navigator.pop(context, 0);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Text('音效一'),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                // 返回2
                Navigator.pop(context, 1);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Text('音效二'),
              ),
            ),
          ],
        );
      });
  return i;
}

_setSoundType(int soundtype) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // print('_setSoundType: $soundtype');
  await prefs.setInt('sound', soundtype);
}
