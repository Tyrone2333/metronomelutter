import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class Summerscar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Opacity(
        opacity: 0,
        child: Container(
          padding: EdgeInsets.only(bottom: 10),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  style: TextStyle(
                    color: Colors.grey[400]
                  ),
                  text: 'by ',
                ),
                TextSpan(
                  style: TextStyle(color: Color.fromARGB(255, 102, 204, 255)),
                  text: 'summerscar',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      String url = 'https://github.com/summerscar';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                ),
              ],
            ),
          ),
        ));
  }
}
