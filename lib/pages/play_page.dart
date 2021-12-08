import 'dart:ui';

import 'package:aoku/components/album_art.dart';
import 'package:aoku/components/aoi_progress_bar.dart';
import 'package:aoku/components/heart_button.dart';
import 'package:aoku/components/info_text.dart';
import 'package:aoku/components/next_button.dart';
import 'package:aoku/components/pause_button.dart';
import 'package:aoku/components/play_button.dart';
import 'package:aoku/components/previous_button.dart';
import 'package:aoku/models/audio_state.dart';
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
    audioState.load();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.chevron_left),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: SweepGradient(
                colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.primary,
                ],
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Container(color: Colors.transparent),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.12),
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
                      audioState.aoiSounds[audioState.index].title,
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
                        const HeartButton(),
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
                    const PreviousButton(),
                    const SizedBox(width: 40),
                    audioState.isPlaying
                        ? const PauseButton()
                        : const PlayButton(),
                    const SizedBox(width: 40),
                    const NextButton(),
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
