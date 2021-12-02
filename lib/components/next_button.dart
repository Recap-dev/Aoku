import 'package:aoku/models/aoi_sound.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    Key? key,
    required this.aoiSounds,
    required this.currentIndex,
    this.onPressed,
  }) : super(key: key);

  final List<AoiSound> aoiSounds;
  final int currentIndex;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: currentIndex == aoiSounds.length - 1 ? null : onPressed,
      icon: Icon(
        CupertinoIcons.forward_fill,
        color: currentIndex == aoiSounds.length - 1
            ? Theme.of(context).colorScheme.onBackground.withOpacity(0.4)
            : Theme.of(context).colorScheme.onBackground,
      ),
      iconSize: 48,
    );
  }
}
