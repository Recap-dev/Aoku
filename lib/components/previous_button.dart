// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';

// 🌎 Project imports:
import 'package:aoku/models/audio_state.dart';

class PreviousButton extends HookConsumerWidget {
  const PreviousButton._({
    Key? key,
    required this.size,
  }) : super(key: key);

  factory PreviousButton.small() => const PreviousButton._(size: 30);

  factory PreviousButton.large() => const PreviousButton._(size: 40);

  final double size;

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
                audioState.initStatus != AudioStateInitStatus.done
            ? Theme.of(context).colorScheme.onBackground.withOpacity(0.3)
            : Theme.of(context).colorScheme.onBackground,
      ),
      iconSize: 40,
    );
  }
}
