import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metronomelutter/config/config.dart';
import 'package:metronomelutter/utils/global_function.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class SliderRow extends StatelessWidget {
  final int bpm;
  final Function setBpmHandler;
  final bool isRunning;
  final Function toggleRunning;
  final AnimationController _animationController;

  SliderRow(this.bpm, this.setBpmHandler, this.isRunning, this.toggleRunning, this._animationController);

  final textController = new TextEditingController();

  handleSliderChange(double value) {
    setBpmHandler(value.toInt());
  }

  handleSetBPMConfirm(text) {
    var bpm;
    try {
      bpm = double.parse(text);
    } catch (e) {
      print('转换失败 $text ');
    }
    if (bpm != null) {
      if (bpm < Config.BPM_MIN || bpm > Config.BPM_MAX) {
        return $warn('BPM 支持 ${Config.BPM_MIN} -  ${Config.BPM_MAX}');
      }
      handleSliderChange(bpm);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () {
            $confirm(
              '',
              context,
              title: 'BPM',
              customBody: TextField(
                controller: textController,
                keyboardType: TextInputType.number,
                // 如果你想只输入数字,需要加上这个
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                ],
                decoration: InputDecoration(
                  hintText: this.bpm.toString(),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                onSubmitted: (text) {
                  Navigator.of(context).pop();
                  handleSetBPMConfirm(text);
                },
              ),
              btnOkOnPress: () => handleSetBPMConfirm(textController.text),
            );
          },
          child: SleekCircularSlider(
              min: Config.BPM_MIN.toDouble(),
              max: Config.BPM_MAX.toDouble(),
              initialValue: this.bpm.toDouble(),
              appearance: CircularSliderAppearance(
                  size: 270,
                  infoProperties: InfoProperties(
                    modifier: (percentage) => percentage.toInt().toString(),
                    bottomLabelText: 'BPM',
                  ),
                  customColors: CustomSliderColors(hideShadow: true, progressBarColors: [
                    Color.fromARGB(255, 62, 164, 255),
                    Color.fromARGB(255, 102, 204, 255),
                    Color.fromARGB(255, 142, 244, 255)
                  ])),
              onChange: handleSliderChange),
        ),
      ],
    );
  }
}
