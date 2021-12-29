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
  const NextButton._({
    Key? key,
    required this.size,
  }) : super(key: key);

  factory NextButton.small() => const NextButton._(size: 30);

  factory NextButton.large() => const NextButton._(size: 40);

  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AudioState audioState = ref.watch(audioProvider);

    return IconButton(
      onPressed: () async {
        if (!audioState.hasNext ||
            audioState.initStatus != AudioStateInitStatus.done ||
            audioState.processingState == ProcessingState.buffering ||
            audioState.processingState == ProcessingState.loading) {
          null;
        } else {
          HapticFeedback.lightImpact();
          await audioState.player.seekToNext();
          audioState.play(audioState.currentIndex);
        }
      },
      icon: Icon(
        CupertinoIcons.forward_fill,
        color: !audioState.hasNext ||
                audioState.initStatus != AudioStateInitStatus.done
            ? Theme.of(context).colorScheme.onBackground.withOpacity(0.3)
            : Theme.of(context).colorScheme.onBackground,
      ),
      iconSize: size,
    );
  }
}
