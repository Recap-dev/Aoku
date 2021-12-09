import 'package:aoku/components/pause_button.dart';
import 'package:aoku/components/play_button.dart';
import 'package:aoku/models/audio_state.dart';
import 'package:aoku/pages/play_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
              showCupertinoModalBottomSheet(
                context: context,
                builder: (context) => PlayPage(
                  initialIndex: audioState.index,
                ),
              );
            },
      child: Container(
        width: double.infinity,
        height: 90.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.secondary.withOpacity(0.8),
              Theme.of(context).colorScheme.primary,
            ],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(24.0)),
        ),
        child: Stack(
          children: [
            Center(
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
            Positioned(
              bottom: 0.0,
              left: 0.0,
              child: Container(
                // Take the progress of the current song in percentage
                width: audioState.isPlaying
                    ? audioState.position.inMilliseconds.toDouble() /
                        audioState.duration.inMilliseconds.toDouble() *
                        MediaQuery.of(context).size.width
                    : 0.0,
                height: 4.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                      Theme.of(context).colorScheme.primary,
                    ],
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(2.0)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
