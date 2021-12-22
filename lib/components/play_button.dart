import 'package:aoku/models/audio_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class PlayButton extends HookConsumerWidget {
  const PlayButton({
    Key? key,
    this.size = 56.0,
  }) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AudioState audioState = ref.watch(audioProvider);

    return IconButton(
      onPressed: () => audioState.initStatus != AudioStateInitStatus.done ||
              audioState.processingState == ProcessingState.buffering ||
              audioState.processingState == ProcessingState.loading
          ? null
          : audioState.play(audioState.currentIndex),
      icon: Icon(
        CupertinoIcons.play_fill,
        color: audioState.initStatus != AudioStateInitStatus.done ||
                audioState.processingState == ProcessingState.buffering ||
                audioState.processingState == ProcessingState.loading
            ? Theme.of(context).colorScheme.onBackground.withOpacity(0.3)
            : Theme.of(context).colorScheme.onBackground,
      ),
      iconSize: size,
    );
  }
}
