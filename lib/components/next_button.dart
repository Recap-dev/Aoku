import 'package:aoku/models/audio_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
      onPressed: audioState.initStatus == AudioStateInitStatus.done
          ? audioState.player.hasNext
              ? () => audioState.player.seekToNext()
              : null
          : null,
      icon: Icon(
        CupertinoIcons.forward_fill,
        color: audioState.initStatus == AudioStateInitStatus.done
            ? audioState.player.hasNext
                ? Theme.of(context).colorScheme.onBackground
                : Theme.of(context).colorScheme.onBackground.withOpacity(0.4)
            : Theme.of(context).colorScheme.onBackground.withOpacity(0.4),
      ),
      iconSize: size,
    );
  }
}
