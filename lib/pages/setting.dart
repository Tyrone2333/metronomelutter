import 'package:flutter/material.dart';
import 'package:metronome/component/about_me.dart';
import 'package:metronome/component/change_sound.dart';
import 'package:metronome/store/index.dart';
import 'package:metronome/utils/global_function.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: Column(
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
          // 源码
          buildInkWellSettingItem(
            '源码',
            context,
            onTap: () async {
              launchURL('https://github.com/Tyrone2333/metronomelutter');
            },
          ),
          // 关于
          buildInkWellSettingItem(
            '关于',
            context,
            onTap: () async {
              PackageInfo packageInfo = await PackageInfo.fromPlatform();

              String version = packageInfo.version;
              String buildNumber = packageInfo.buildNumber;

              if (!context.mounted) return;
              showDialog(
                context: context,
                builder: (ctx) => AboutMe(version: 'v$version+$buildNumber'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildInkWellSettingItem(
    String text,
    BuildContext context, {
    final VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
