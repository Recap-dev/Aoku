import 'package:aoku/models/audio_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InfoText extends HookConsumerWidget {
  const InfoText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AudioState audioState = ref.watch(audioProvider);

    return Text(
      '${audioState.aoiSounds[audioState.index].time.hour.toString()}:${audioState.aoiSounds[audioState.index].time.minute.toString()} at ${audioState.aoiSounds[audioState.index].city}, ${audioState.aoiSounds[audioState.index].province}',
      style: TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
        fontSize: 16.0,
      ),
    );
  }
}
