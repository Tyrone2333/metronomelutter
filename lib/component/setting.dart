import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置')
      ),
      body: Container(
        child: Column(
          children: [
            InkWell(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Text(
                  '音效',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
              onTap: () async {
                final res = await changeSound(context);
                if (res != null) {
                  _setSoundType(res);
                }
              },
            ),
            Builder(
              builder: (context) => InkWell(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Text(
                    '节拍',
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
                onTap: () {
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('还没做呢……')));
                },
              )
            )
          ],
        ),
      ),
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