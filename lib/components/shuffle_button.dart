import 'package:aoku/models/audio_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({
    Key? key,
    required this.audioState,
  }) : super(key: key);

  final AudioState audioState;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: audioState.shuffleModeEnabled
            ? Theme.of(context).colorScheme.onBackground.withOpacity(0.4)
            : Colors.transparent,
      ),
      child: Center(
        child: IconButton(
          onPressed: audioState.toggleShuffleMode,
          icon: Icon(
            CupertinoIcons.shuffle,
            size: 16,
            color: audioState.shuffleModeEnabled
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
    );
  }
}
