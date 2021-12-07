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
      onPressed: audioState.play,
      icon: Icon(
        CupertinoIcons.play_fill,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      iconSize: size,
    );
  }
}
