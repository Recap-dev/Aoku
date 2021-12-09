import 'dart:ui';

import 'package:aoku/components/bottom_player.dart';
import 'package:aoku/components/signin_button.dart';
import 'package:aoku/models/audio_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
            child: SigninButton(),
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
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 24.0,
                bottom: 50.0,
              ),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: audioState.aoiSounds.length,
                itemExtent: 70,
                itemBuilder: (context, _currentIndex) {
                  return buildAoiSoundListTile(
                    context,
                    audioState,
                    _currentIndex,
                  );
                },
              ),
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
        onTap: () {
          audioState.initialIndex = _index;
          audioState.play(isSameSound: false);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 24.0,
              child: Visibility(
                visible: audioState.isPlaying && audioState.index == _index,
                child: Icon(
                  CupertinoIcons.waveform,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    audioState.aoiSounds[_index].title,
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
                        '${audioState.aoiSounds[_index].city}, ${audioState.aoiSounds[_index].province}',
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
                '15:35',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
