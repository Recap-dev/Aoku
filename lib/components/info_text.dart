import 'package:aoku/pages/play_page.dart';
import 'package:flutter/material.dart';

class InfoText extends StatelessWidget {
  const InfoText({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final PlayPage widget;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${widget.aoiSounds[widget.currentIndex].time.hour.toString()}:${widget.aoiSounds[widget.currentIndex].time.minute.toString()} at ${widget.aoiSounds[widget.currentIndex].city}, ${widget.aoiSounds[widget.currentIndex].province}',
      style: TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
        fontSize: 16.0,
      ),
    );
  }
}
