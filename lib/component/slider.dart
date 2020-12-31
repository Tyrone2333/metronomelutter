import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metronomelutter/config/config.dart';
import 'package:metronomelutter/utils/global_function.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    _storeBpm(value.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              $confirm(
                'aaa',
                context,
                customBody: TextField(
                  controller: textController,
                  keyboardType: TextInputType.number,

                  // 如果你想只输入数字,需要加上这个
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                  ], // Only numbers can be entered
                  decoration: InputDecoration(
                    hintText: this.bpm.toString(),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
                btnOkOnPress: () {
                  var bpm;
                  try {
                    bpm = double.parse(textController.text);
                  } catch (e) {
                    print('转换失败 ${textController.text} ');
                  }
                  if (bpm != null) {
                    if (bpm < Config.BPM_MIN || bpm > Config.BPM_MAX) {
                      return $warn('BPM 支持 ${Config.BPM_MIN} -  ${Config.BPM_MAX}');
                    }
                    handleSliderChange(bpm);
                  }
                },
              );
            },
            child: SleekCircularSlider(
                min: 30,
                max: 200,
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
      ),
      IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: _animationController,
        ),
        onPressed: () => toggleRunning(),
        color: Color.fromARGB(255, 102, 204, 255),
      )
    ]);
  }
}

_storeBpm(int bpm) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // print('_setSoundType: $soundtype');
  await prefs.setInt('bpm', bpm);
}
