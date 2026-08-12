import 'package:flutter/material.dart';

class TimeSignature extends StatelessWidget {
  final int beat;
  final int note;

  const TimeSignature(this.beat, this.note, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(beat.toString()),
        const Text('/'),
        Text(note.toString()),
      ],
    );
  }
}
