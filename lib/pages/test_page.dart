import 'package:flutter/material.dart';

class CustomAboutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildAboutDialog(),
        Positioned(top: 50, right: 20, child: _buildRaisedButton(context)),
      ],
    );
  }

  Widget _buildRaisedButton(BuildContext context) => RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        color: Colors.blue,
        onPressed: () {
          showDialog(context: context, builder: (ctx) => _buildAboutDialog());
        },
        child: Text(
          'Just Show It',
          style: TextStyle(color: Colors.white),
        ),
      );

  AboutDialog _buildAboutDialog() {
    return AboutDialog(
      applicationIcon: FlutterLogo(),
      applicationVersion: 'v1.0.0',
      applicationName: '嗷嗷',
      applicationLegalese: 'Copyright© 2018-2020 张风捷特烈',
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 20), width: 80, height: 80, child: Image.asset('assets/images/icon_head.png')),
        Container(
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: Text(
              'The King Of Coder.',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  shadows: [Shadow(color: Colors.blue, offset: Offset(.5, .5), blurRadius: 3)]),
            ))
      ],
    );
  }
}
