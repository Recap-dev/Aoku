import 'package:aoku/models/audio_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PreviousButton extends HookConsumerWidget {
  const PreviousButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AudioState audioState = ref.watch(audioProvider);

    return IconButton(
      onPressed: audioState.player.hasPrevious ? audioState.previous : null,
      icon: Icon(
        CupertinoIcons.backward_fill,
        color: audioState.player.hasPrevious
            ? Theme.of(context).colorScheme.onBackground
            : Theme.of(context).colorScheme.onBackground.withOpacity(0.4),
      ),
      iconSize: 40,
    );
  }
}
