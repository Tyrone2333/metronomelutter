import 'package:flutter/material.dart';

Future<int> changeSound(context) async {
  buildOpt(String name, val) {
    return SimpleDialogOption(
      onPressed: () {
        // 返回1
        Navigator.pop(context, val);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(name),
      ),
    );
  }

  int i = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('请选择音效'),
          children: <Widget>[
            buildOpt('音效一', 0),
            buildOpt('音效二', 1),
            buildOpt('woodblocks', 2),
            buildOpt('beep', 3),
            buildOpt('beep2', 4),
            buildOpt('牛铃', 5),
            buildOpt('钟', 6),
            // 高 bpm 时一些手机声音播放不完全
            buildOpt('鼓', 7),
          ],
        );
      });
  return i;
}
