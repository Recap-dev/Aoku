import 'package:aoku/models/audio_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class RepeatButton extends StatelessWidget {
  const RepeatButton({
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
        color: audioState.loopMode != LoopMode.off
            ? Theme.of(context).colorScheme.onBackground.withOpacity(0.4)
            : Colors.transparent,
      ),
      child: IconButton(
        onPressed: audioState.toggleLoopMode,
        icon: Icon(
          audioState.loopMode != LoopMode.one
              ? CupertinoIcons.repeat
              : CupertinoIcons.repeat_1,
          size: 16,
          color: audioState.loopMode != LoopMode.off
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
  }
}
