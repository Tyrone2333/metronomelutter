import 'package:flutter/material.dart';
import 'package:metronomelutter/component/about_me.dart';
import 'package:metronomelutter/component/change_sound.dart';
import 'package:metronomelutter/store/index.dart';
import 'package:metronomelutter/utils/global_function.dart';
import 'package:package_info/package_info.dart';

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
                PackageInfo packageInfo = await PackageInfo.fromPlatform();

                String appName = packageInfo.appName;
                String packageName = packageInfo.packageName;
                String version = packageInfo.version;
                String buildNumber = packageInfo.buildNumber;
                print('正在检查版本: ---$appName---$packageName---$version---$buildNumber---');

                showDialog(context: context, builder: (ctx) => AboutMe(version: 'v$version+$buildNumber'));

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
