import 'package:flutter/material.dart';

enum StepperEventType { increase, decrease }

typedef StepperChangeCallback = void Function(int val);

// - 3 +
class SyStepper extends StatelessWidget {
  final int value;
  final int min;
  final int max;

  /// 步幅
  final int step;
  final double iconSize;
  final double textSize;
  final StepperChangeCallback? onChange;
  final void Function(StepperEventType type, int nowValue)? manualControl;

  const SyStepper({
    super.key,
    this.value = 1,
    this.onChange,
    this.min = 1,
    this.max = 9999999,
    this.step = 1,
    this.iconSize = 24.0,
    this.textSize = 24.0,
    this.manualControl,
  });

  @override
  Widget build(BuildContext context) {
    int value = this.value;
    ThemeData theme = Theme.of(context);
    const iconPadding = EdgeInsets.all(4.0);
    bool minusBtnDisabled =
        value <= min || value - step < min || onChange == null;
    bool addBtnDisabled =
        value >= max || value + step > max || onChange == null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          onTap: minusBtnDisabled
              ? null
              : manualControl != null
                  ? () => manualControl!(StepperEventType.decrease, value)
                  : () => onChange!(value - step),
          child: Padding(
            padding: iconPadding,
            child: Icon(
              Icons.remove,
              size: iconSize,
              color: minusBtnDisabled
                  ? theme.disabledColor
                  : theme.textTheme.labelLarge?.color,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: iconSize),
            child: Center(
                child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: textSize,
              ),
            )),
          ),
        ),
        InkWell(
          onTap: addBtnDisabled
              ? null
              : manualControl != null
                  ? () => manualControl!(StepperEventType.increase, value)
                  : () => onChange!(value + step),
          child: Padding(
            padding: iconPadding,
            child: Icon(
              Icons.add,
              size: iconSize,
              color: addBtnDisabled
                  ? theme.disabledColor
                  : theme.textTheme.labelLarge?.color,
            ),
          ),
        ),
      ],
    );
  }
}
