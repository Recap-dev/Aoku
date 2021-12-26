import 'dart:math';

import 'package:aoku/models/audio_state.dart';
import 'package:aoku/pages/play_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ShuffleToPlayButton extends StatelessWidget {
  const ShuffleToPlayButton({
    Key? key,
    required this.audioState,
  }) : super(key: key);

  final AudioState audioState;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        HapticFeedback.lightImpact();
        await audioState.toggleShuffleMode(forceEnable: true);
        await audioState.toggleLoopMode(forceEnable: true);
        showCupertinoModalBottomSheet(
          context: context,
          builder: (context) => const PlayPage(),
        );
        audioState.play(
          Random().nextInt(audioState.sounds.length),
        );
      },
      iconSize: 48.0,
      icon: Stack(
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          Align(
            alignment: const Alignment(0.3, 0.1),
            child: Icon(
              CupertinoIcons.play_fill,
              color: Theme.of(context).colorScheme.surface,
              size: 30.0,
            ),
          ),
          Align(
            alignment: const Alignment(1.2, 1.2),
            child: Container(
              width: 16.0,
              height: 16.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Center(
                child: Icon(
                  CupertinoIcons.shuffle,
                  color: Theme.of(context).colorScheme.onBackground,
                  size: 8.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
