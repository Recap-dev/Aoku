import 'package:aoku/models/audio_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
      onPressed: () =>
          audioState.isInitialized ? audioState.play(isSameSound: true) : null,
      icon: Icon(
        CupertinoIcons.play_fill,
        color: audioState.isInitialized
            ? Theme.of(context).colorScheme.onBackground
            : Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
      ),
      iconSize: size,
    );
  }
}
