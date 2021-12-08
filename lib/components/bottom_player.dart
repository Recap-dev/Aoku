import 'package:aoku/components/pause_button.dart';
import 'package:aoku/components/play_button.dart';
import 'package:aoku/models/audio_state.dart';
import 'package:aoku/pages/play_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BottomPlayer extends HookConsumerWidget {
  const BottomPlayer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AudioState audioState = ref.watch(audioProvider);

    return GestureDetector(
      onTap: !audioState.isPlaying
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PlayPage(initialIndex: audioState.index),
                ),
              );
            },
      child: Container(
        width: double.infinity,
        height: 100.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.primary,
            ],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(24.0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 12.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                audioState.isPlaying
                    ? audioState.aoiSounds[audioState.index].title
                    : 'Not Playing',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            audioState.isPlaying
                ? const PauseButton(size: 30.0)
                : const PlayButton(size: 30.0),
            const SizedBox(width: 12.0),
          ],
        ),
      ),
    );
  }
}
