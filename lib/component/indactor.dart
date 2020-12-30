import 'package:flutter/material.dart';

class IndactorRow extends StatelessWidget {
  final int nowStep;
  final List steps = List(4);
  IndactorRow(this.nowStep);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: steps
            .asMap()
            .entries
            .map((entry) => Container(
                margin: EdgeInsets.all(25),
                width: entry.key == 0 ? 35.0 : 25.0,
                height: entry.key == 0 ? 35.0 : 25.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: this.nowStep > -1 &&
                            (this.nowStep % steps.length) == entry.key
                        ? Color.fromARGB(255, 102, 204, 255)
                        : Colors.grey[300])))
            .toList());
  }
}
