import 'package:flutter/material.dart';

class IndactorRow extends StatelessWidget {
  final int nowStep;
  final int stepLength;

  const IndactorRow(this.nowStep, this.stepLength, {super.key});

  @override
  Widget build(BuildContext context) {
    final steps = List.generate(stepLength, (i) => i);
    final Color accent = Theme.of(context).colorScheme.secondary;
    // 不满 4 个改用 Row 渲染
    if (stepLength < 4) {
      return SizedBox(
        height: 100,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: steps
                .asMap()
                .entries
                .map((entry) => Container(
                      margin: const EdgeInsets.all(25),
                      width: entry.key == 0 ? 35.0 : 25.0,
                      height: entry.key == 0 ? 35.0 : 25.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: nowStep > -1 &&
                                  (nowStep % steps.length) == entry.key
                              ? accent
                              : Colors.grey[300]),
                    ))
                .toList()),
      );
    }
    return Container(
      height: 100,
      alignment: Alignment.center,
      child: GridView.builder(
        itemCount: steps.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: steps.length > 4 ? steps.length : 4,
          mainAxisSpacing: 0.0,
          childAspectRatio: 1.0,
        ),
        padding: const EdgeInsets.symmetric(vertical: 0),
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Container(
              width: index == 0 ? 35.0 : 25.0,
              height: index == 0 ? 35.0 : 25.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: nowStep > -1 && (nowStep % steps.length) == index
                      ? accent
                      : Colors.grey[300]),
            ),
          );
        },
      ),
    );
  }
}
