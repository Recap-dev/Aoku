// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// 🌎 Project imports:
import 'package:aoku/components/next_button.dart';
import 'package:aoku/components/pause_button.dart';
import 'package:aoku/components/play_button.dart';
import 'package:aoku/models/audio_state.dart';
import 'package:aoku/pages/play_page.dart';

class BottomPlayer extends HookConsumerWidget {
  const BottomPlayer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AudioState audioState = ref.watch(audioProvider);

    return GestureDetector(
      onTap: audioState.initStatus != AudioStateInitStatus.done
          ? null
          : () => showCupertinoModalBottomSheet(
                context: context,
                builder: (context) => const PlayPage(),
              ),
      child: Container(
        width: double.infinity,
        height: 60.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.secondary.withOpacity(0.8),
              Theme.of(context).colorScheme.primary,
            ],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 60.0,
                      child: audioState.initStatus == AudioStateInitStatus.done
                          ? Icon(
                              CupertinoIcons.waveform,
                              color: audioState.isPlaying
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.1),
                            )
                          : null,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        audioState.initStatus == AudioStateInitStatus.done
                            ? audioState.sounds[audioState.currentIndex].title
                            : '',
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
                    const NextButton(size: 30.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
