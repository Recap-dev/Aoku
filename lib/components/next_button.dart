import 'package:aoku/models/audio_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NextButton extends HookConsumerWidget {
  const NextButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AudioState audioState = ref.watch(audioProvider);

    return IconButton(
      onPressed: audioState.index == audioState.aoiSounds.length - 1
          ? null
          : audioState.next,
      icon: Icon(
        CupertinoIcons.forward_fill,
        color: audioState.index == audioState.aoiSounds.length - 1
            ? Theme.of(context).colorScheme.onBackground.withOpacity(0.4)
            : Theme.of(context).colorScheme.onBackground,
      ),
      iconSize: 40,
    );
  }
}
