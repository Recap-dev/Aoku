import 'package:aoku/models/audio_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PauseButton extends HookConsumerWidget {
  const PauseButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AudioState audioState = ref.watch(audioProvider);

    return IconButton(
      onPressed: audioState.pause,
      icon: Icon(
        CupertinoIcons.pause_fill,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      iconSize: 56,
    );
  }
}
