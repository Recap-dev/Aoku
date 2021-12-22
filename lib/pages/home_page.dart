import 'dart:ui';
import 'dart:math';

import 'package:aoku/components/aoi_sound_list_tile.dart';
import 'package:aoku/components/bottom_player.dart';
import 'package:aoku/components/profile_button.dart';
import 'package:aoku/models/audio_state.dart';
import 'package:aoku/pages/play_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AudioState audioState = ref.watch(audioProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: ProfileButton(),
          ),
        ],
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
          FutureBuilder(
            future: audioState.init(0),
            builder: (context, snapshot) {
              if (snapshot.data != AudioStateInitStatus.done) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color:
                      Theme.of(context).colorScheme.background.withOpacity(0.1),
                  child: Center(
                    child: Text(
                      'Loading...',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 24.0,
                ),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: audioState.sounds.length + 1,
                  itemExtent: 70,
                  itemBuilder: (context, _currentIndex) {
                    if (_currentIndex == 0) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () async {
                              HapticFeedback.mediumImpact();
                              await audioState.toggleShuffleMode(
                                  forceEnable: true);
                              await audioState.toggleLoopMode(
                                  forceEnable: true);
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

                    return AoiSoundListTile(
                      context: context,
                      audioState: audioState,
                      index: _currentIndex - 1,
                    );
                  },
                ),
              );
            },
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: BottomPlayer(),
          ),
        ],
      ),
    );
  }
}
