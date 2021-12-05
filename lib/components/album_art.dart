import 'dart:ui';

import 'package:aoku/models/audio_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AlbumArt extends HookConsumerWidget {
  const AlbumArt({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AudioState audioState = ref.watch(audioProvider);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.onBackground,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              audioState.aoiSounds[audioState.index].title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 24.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
