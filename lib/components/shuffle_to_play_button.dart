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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
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
          icon: Icon(
            CupertinoIcons.shuffle,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
    );
  }
}
