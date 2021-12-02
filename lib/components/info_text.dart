import 'package:aoku/models/aoi_sound.dart';
import 'package:flutter/material.dart';

class InfoText extends StatelessWidget {
  const InfoText({
    Key? key,
    required this.aoiSounds,
    required this.currentIndex,
  }) : super(key: key);

  final List<AoiSound> aoiSounds;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${aoiSounds[currentIndex].time.hour.toString()}:${aoiSounds[currentIndex].time.minute.toString()} at ${aoiSounds[currentIndex].city}, ${aoiSounds[currentIndex].province}',
      style: TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
        fontSize: 16.0,
      ),
    );
  }
}
