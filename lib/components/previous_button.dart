import 'package:aoku/models/audio_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class PreviousButton extends HookConsumerWidget {
  const PreviousButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AudioState audioState = ref.watch(audioProvider);

    return IconButton(
      onPressed: () {
        if (!audioState.hasPrevious ||
            audioState.initStatus != AudioStateInitStatus.done ||
            audioState.processingState == ProcessingState.buffering ||
            audioState.processingState == ProcessingState.loading) {
          null;
        } else {
          HapticFeedback.lightImpact();
          audioState.previous();
        }
      },
      icon: Icon(
        CupertinoIcons.backward_fill,
        color: !audioState.hasPrevious ||
                audioState.initStatus != AudioStateInitStatus.done ||
                audioState.processingState == ProcessingState.buffering ||
                audioState.processingState == ProcessingState.loading
            ? Theme.of(context).colorScheme.onBackground.withOpacity(0.3)
            : Theme.of(context).colorScheme.onBackground,
      ),
      iconSize: 40,
    );
  }
}
