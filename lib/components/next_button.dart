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
      onPressed: audioState.isInitialized
          ? audioState.index != audioState.aoiSounds.length - 1
              ? () => audioState.next()
              : null
          : null,
      icon: Icon(
        CupertinoIcons.forward_fill,
        color: audioState.isInitialized
            ? audioState.index != audioState.aoiSounds.length - 1
                ? Theme.of(context).colorScheme.onBackground
                : Theme.of(context).colorScheme.onBackground.withOpacity(0.4)
            : Theme.of(context).colorScheme.onBackground.withOpacity(0.4),
      ),
      iconSize: size,
    );
  }
}
