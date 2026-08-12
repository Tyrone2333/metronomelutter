import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metronome/config/config.dart';
import 'package:metronome/utils/global_function.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class SliderRow extends StatelessWidget {
  final int bpm;
  final void Function(int) setBpmHandler;

  SliderRow(this.bpm, this.setBpmHandler, {super.key});

  final textController = TextEditingController();

  void handleSliderChange(double value) {
    setBpmHandler(value.toInt());
  }

  void handleSetBPMConfirm(String text) {
    double? parsed;
    try {
      parsed = double.parse(text);
    } catch (e) {
      debugPrint('转换失败 $text ');
    }
    if (parsed != null) {
      if (parsed < Config.BPM_MIN || parsed > Config.BPM_MAX) {
        $warn('BPM 支持 ${Config.BPM_MIN} -  ${Config.BPM_MAX}');
        return;
      }
      handleSliderChange(parsed);
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
                  hintText: bpm.toString(),
                  filled: true,
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
            initialValue: bpm.toDouble(),
            appearance: CircularSliderAppearance(
                size: 270,
                infoProperties: InfoProperties(
                  modifier: (percentage) => percentage.toInt().toString(),
                  bottomLabelText: 'BPM',
                  mainLabelStyle: TextStyle(
                    color: Theme.of(context).textTheme.titleLarge?.color,
                    fontSize: 52,
                  ),
                ),
                customColors: CustomSliderColors(
                    hideShadow: true,
                    progressBarColors: [
                      const Color.fromARGB(255, 62, 164, 255),
                      const Color.fromARGB(255, 102, 204, 255),
                      const Color.fromARGB(255, 142, 244, 255),
                    ])),
            onChange: handleSliderChange,
          ),
        ),
      ],
    );
  }
}
