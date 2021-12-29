// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';

// 🌎 Project imports:
import 'package:aoku/models/audio_state.dart';

class NextButton extends HookConsumerWidget {
  const NextButton({
    Key? key,
    this.size = 40,
  }) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AudioState audioState = ref.watch(audioProvider);

    return IconButton(
      onPressed: () {
        if (!audioState.hasNext ||
            audioState.initStatus != AudioStateInitStatus.done ||
            audioState.processingState == ProcessingState.buffering ||
            audioState.processingState == ProcessingState.loading) {
          null;
        } else {
          HapticFeedback.lightImpact();
          audioState.player.seekToNext();
        }
      },
      icon: Icon(
        CupertinoIcons.forward_fill,
        color: !audioState.hasNext ||
                audioState.initStatus != AudioStateInitStatus.done ||
                audioState.processingState == ProcessingState.buffering ||
                audioState.processingState == ProcessingState.loading
            ? Theme.of(context).colorScheme.onBackground.withOpacity(0.3)
            : Theme.of(context).colorScheme.onBackground,
      ),
      iconSize: size,
    );
  }
}
