// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:aoku/components/album_art.dart';
import 'package:aoku/components/aoi_progress_bar.dart';
import 'package:aoku/components/frosted_background.dart';
import 'package:aoku/components/heart_button.dart';
import 'package:aoku/components/info_text.dart';
import 'package:aoku/components/next_button.dart';
import 'package:aoku/components/pause_button.dart';
import 'package:aoku/components/play_button.dart';
import 'package:aoku/components/previous_button.dart';
import 'package:aoku/components/repeat_button.dart';
import 'package:aoku/components/shuffle_button.dart';
import 'package:aoku/models/audio_state.dart';

class PlayPage extends HookConsumerWidget {
  const PlayPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AudioState audioState = ref.watch(audioProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const FrostedBackground(),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.12,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const AlbumArt(),
                    const SizedBox(height: 48.0),
                    Divider(
                      color: Theme.of(context).colorScheme.onBackground,
                      thickness: 0.8,
                    ),
                    Text(
                      audioState.initStatus == AudioStateInitStatus.done
                          ? audioState.sounds[audioState.currentIndex].title
                          : 'Loading...',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 24.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: const InfoText(),
                        ),
                        HeartButton.enabled(onPressed: null),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const AoiProgressBar(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const ShuffleButton(),
                    const SizedBox(width: 5),
                    PreviousButton.large(),
                    audioState.isPlaying
                        ? PauseButton.large()
                        : PlayButton.large(),
                    NextButton.large(),
                    const SizedBox(width: 5),
                    const RepeatButton(),
                  ],
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
