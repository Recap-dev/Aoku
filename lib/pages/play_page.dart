import 'package:aoku/components/album_art.dart';
import 'package:aoku/components/aoi_progress_bar.dart';
import 'package:aoku/components/heart_button.dart';
import 'package:aoku/components/map_button.dart';
import 'package:aoku/components/info_text.dart';
import 'package:aoku/components/next_button.dart';
import 'package:aoku/components/pause_button.dart';
import 'package:aoku/components/play_button.dart';
import 'package:aoku/components/previous_button.dart';
import 'package:aoku/models/audio_state.dart';
import 'package:aoku/pages/map_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlayPage extends HookConsumerWidget {
  const PlayPage({
    Key? key,
    required this.initialIndex,
  }) : super(key: key);

  final int initialIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AudioState audioState = ref.watch(audioProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        shadowColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            audioState.stop();
          },
          icon: const Icon(CupertinoIcons.chevron_left),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(1.0, -1.0),
                child: Image.asset(
                  'images/orange-blur.png',
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: const Alignment(-1.0, 1.0),
                child: Image.asset(
                  'images/blue-blur-1.png',
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      AlbumArt(
                        aoiSounds: audioState.aoiSounds,
                        currentIndex: audioState.index,
                      ),
                      const SizedBox(
                        height: 48.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const HeartButton(),
                          InfoText(
                            aoiSounds: audioState.aoiSounds,
                            currentIndex: audioState.index,
                          ),
                          MapButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapPage(
                                    initialLocation: audioState
                                        .aoiSounds[audioState.index].location,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  AoiProgressBar(
                    currentPosition: audioState.position,
                    currentDuration: audioState.duration,
                    audioPlayer: audioState.audioPlayer,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PreviousButton(
                        currentIndex: audioState.index,
                        onPressed: audioState.previous,
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      audioState.isPlaying
                          ? PauseButton(onPressed: audioState.pause)
                          : PlayButton(
                              onPressed: () => audioState.play(),
                            ),
                      const SizedBox(
                        width: 40,
                      ),
                      NextButton(
                        aoiSounds: audioState.aoiSounds,
                        currentIndex: audioState.index,
                        onPressed: audioState.next,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 64,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
