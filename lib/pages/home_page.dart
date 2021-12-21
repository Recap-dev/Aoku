import 'dart:ui';
import 'dart:math';

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
          Padding(
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

                return buildAoiSoundListTile(
                  context,
                  audioState,
                  _currentIndex - 1,
                );
              },
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: BottomPlayer(),
          ),
        ],
      ),
    );
  }

  Center buildAoiSoundListTile(
    BuildContext context,
    AudioState audioState,
    int _index,
  ) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          HapticFeedback.lightImpact();
          showCupertinoModalBottomSheet(
            context: context,
            builder: (context) => const PlayPage(),
          );
          await audioState.play(_index);
        },
        child: Container(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 24.0,
                child: Visibility(
                  visible: _index == audioState.player.currentIndex,
                  child: audioState.initStatus == AudioStateInitStatus.done
                      ? Icon(
                          CupertinoIcons.waveform,
                          color: Theme.of(context).colorScheme.onBackground,
                        )
                      : const CupertinoActivityIndicator(),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      audioState.sounds[_index].title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          CupertinoIcons.map_pin,
                          color: Theme.of(context).colorScheme.onBackground,
                          size: 12.0,
                        ),
                        Text(
                          '${audioState.sounds[_index].city}, ${audioState.sounds[_index].province}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 10.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 12.0,
                child: Icon(
                  CupertinoIcons.heart_solid,
                  color: Theme.of(context).colorScheme.onBackground,
                  size: 16.0,
                ),
              ),
              SizedBox(
                width: 32.0,
                child: Text(
                  '${audioState.sounds[_index].length.inMinutes.toString().padLeft(2, '  ')}:${audioState.sounds[_index].length.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
