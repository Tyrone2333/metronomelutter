import 'dart:async';

import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

void $warn(
  String text, {
  gravity: ToastGravity.CENTER,
  toastLength: Toast.LENGTH_SHORT,
}) {
  Fluttertoast.cancel();

  Fluttertoast.showToast(
    msg: text,
    toastLength: toastLength,
    gravity: gravity,
    timeInSecForIosWeb: 1,
    backgroundColor: Color(0xcc000000),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

// 连个提示框都要自己封装...
Future<void> $confirm(
  String text,
  BuildContext context, {
  final Function btnOkOnPress,
  final Function btnCancelOnPress,
  title = '提示',
  confirmText = '确定',
  cancelText = '取消',
  Widget customBody,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: customBody != null
              ? customBody
              : ListBody(
                  children: <Widget>[
                    Text(text),
                  ],
                ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(confirmText),
            onPressed: () {
              Navigator.of(context).pop();

              if (btnOkOnPress != null) {
                btnOkOnPress();
              }
            },
          ),
          FlatButton(
            child: Text(
              cancelText,
//              style: TextStyle(
//                color: Color(0xff333333),
//              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              if (btnCancelOnPress != null) {
                btnCancelOnPress();
              }
            },
          ),
        ],
      );
    },
  );
}

// 复制到剪切板
Future<String> copyToClipboard(
  String text, {
  gravity: ToastGravity.CENTER,
}) async {
  //复制
  Clipboard.setData(ClipboardData(text: text));

  var res = '';
  try {
    //读取剪切板
    var textFu = await Clipboard.getData(Clipboard.kTextPlain);
    if (text == textFu.text) {
      res = textFu.text;
      // 个人中心的复制会真好的黑色的邀请重合,这里让弹窗放到上面去
      $warn('复制成功', gravity: gravity);
    } else {
      throw ('设置失败');
    }
  } catch (e) {
    print(e);

    $warn('复制失败', gravity: gravity);
  }
  print('剪贴板: ' + res);

  return res;
}

// 自动超时关闭
Timer _loadingClosedTimer;

$loading(context,
    {title = '加载中',

    /// 可能会有打开后没触发关闭的地方,默认开启超时关闭防止页面 loading 停留过久
    closedTimeout = 3}) {
  showProgressDialog(
    context: context,
    orientation: ProgressOrientation.vertical,
    loadingText: title,
  );

//  超过预期时间仍未关闭 loading
  if (_loadingClosedTimer != null) {
    _loadingClosedTimer.cancel();
  }
  _loadingClosedTimer = new Timer(new Duration(seconds: closedTimeout), () {
    $loadingHide();
  });
}

$loadingHide() {
  dismissProgressDialog();
}

/// 和 js 的 setTimeout 一样
Future setTimeout(cb, int time) async {
  return Timer(Duration(milliseconds: time), cb);
}

/// 根据 value 找到 key
findKeyByValue(Map map, dynamic val) {
  return map.keys.firstWhere((k) => map[k] == val, orElse: () => null);
}

launchURL(url) async {
  if (await canLaunch(url)) {
    return launch(url);
  } else {
    throw '无法拉起: $url';
  }
}

buildNum({num = 200}) {
  return ListView.builder(
//    shrinkWrap: true, //解决无线高度问题
//    physics: new NeverScrollableScrollPhysics(), //禁用滑动事件
    itemCount: num,
    itemBuilder: (context, index) {
      return Container(
        alignment: Alignment.center,
        color: Colors.teal[100 * (index % 9)],
        child: Text('item2 $index'),
      );
    },
  );
}

get isRelease {
  return foundation.kReleaseMode;
}

// 补全头部 https:// 前缀
// 如果修改请运行 单元测试 `unit_test.dart - '填充 url https://'` 验证正确性
completeUrlHttpsPrefix(urlOrigin) {
//  print('原版 url: $urlOrigin');

  var url = urlOrigin;

  url = (RegExp(r"^//").hasMatch(url) || RegExp(r"^http(s|)").hasMatch(url)) ? url : '//' + url;

  return RegExp(r"^http(s|)").hasMatch(url) ? url : 'https:' + url;
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
