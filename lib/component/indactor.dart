import 'package:flutter/material.dart';

class IndactorRow extends StatelessWidget {
  final int nowStep;
  final int stepLength;

  IndactorRow(this.nowStep, this.stepLength);

  @override
  Widget build(BuildContext context) {
    final List steps = List(stepLength);
    return Container(
      height: 100,
      // color: Colors.blueGrey,
      alignment: Alignment.center,
      child: GridView.builder(
        itemCount: steps.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: steps.length,
          mainAxisSpacing: 0.0,
          childAspectRatio: 1.0,
        ),
        padding: EdgeInsets.symmetric(vertical: 0),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Center(
              child: Container(
                // margin: EdgeInsets.all(25),
                width: index == 0 ? 35.0 : 25.0,
                height: index == 0 ? 35.0 : 25.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: this.nowStep > -1 && (this.nowStep % steps.length) == index
                        ? Color.fromARGB(255, 102, 204, 255)
                        : Colors.grey[300]),
              ),
            ),
          );
        },
      ),
    );
  }
}
