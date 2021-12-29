// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';

// 🌎 Project imports:
import 'package:aoku/models/audio_state.dart';

class PlayButton extends HookConsumerWidget {
  const PlayButton._({
    Key? key,
    required this.size,
  }) : super(key: key);

  factory PlayButton.large({Key? key}) => PlayButton._(key: key, size: 56);

  factory PlayButton.small({Key? key}) => PlayButton._(key: key, size: 30);

  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AudioState audioState = ref.watch(audioProvider);

    return IconButton(
      onPressed: () {
        if (audioState.initStatus != AudioStateInitStatus.done ||
            audioState.processingState == ProcessingState.buffering ||
            audioState.processingState == ProcessingState.loading) {
          null;
        } else {
          HapticFeedback.lightImpact();
          audioState.play(audioState.currentIndex);
        }
      },
      icon: Icon(
        CupertinoIcons.play_fill,
        color: audioState.initStatus != AudioStateInitStatus.done
            ? Theme.of(context).colorScheme.onBackground.withOpacity(0.3)
            : Theme.of(context).colorScheme.onBackground,
      ),
      iconSize: size,
    );
  }
}
