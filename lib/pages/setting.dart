import 'package:flutter/material.dart';
import 'package:metronomelutter/component/about_me.dart';
import 'package:metronomelutter/store/index.dart';
import 'package:metronomelutter/utils/global_function.dart';

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
                  appStore.setSoundType(res);
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
                showDialog(context: context, builder: (ctx) => AboutMe());

                // $confirm(
                //   '基于 flutter 技术打造的极简全平台节拍器', context,
                //   // customBody: Text('222'),
                // );
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
            buildOpt('音效三', 2),
          ],
        );
      });
  return i;
}
