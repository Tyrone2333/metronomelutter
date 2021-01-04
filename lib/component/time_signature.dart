import 'package:flutter/material.dart';

class TimeSignature extends StatelessWidget {
  final int beat;
  final int note;

  TimeSignature(this.beat, this.note);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(beat.toString()),
        Text('/'),
        Text(note.toString()),
      ],
    );
  }
}
