import 'package:aoku/models/audio_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InfoText extends HookConsumerWidget {
  const InfoText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AudioState audioState = ref.watch(audioProvider);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              CupertinoIcons.map_pin_ellipse,
              size: 12.0,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            const SizedBox(width: 4.0),
            Text(
              audioState.initStatus == AudioStateInitStatus.done
                  ? '${audioState.sounds[audioState.currentIndex].city}, ${audioState.sounds[audioState.currentIndex].province}'
                  : 'Loading...',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              CupertinoIcons.calendar_today,
              size: 12.0,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            const SizedBox(width: 4.0),
            Text(
              audioState.initStatus == AudioStateInitStatus.done
                  ? audioState.sounds[audioState.currentIndex].time
                      .format(context)
                  : 'Loading...',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
