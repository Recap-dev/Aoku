import 'package:aoku/components/aoi_sound_list_tile.dart';
import 'package:aoku/components/bottom_player.dart';
import 'package:aoku/components/frosted_background.dart';
import 'package:aoku/components/profile_button.dart';
import 'package:aoku/components/shuffle_to_play_button.dart';
import 'package:aoku/models/audio_state.dart';
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
            child: ProfileButton(),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const FrostedBackground(),
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

              return Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 160,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 24.0),
                        child: ShuffleToPlayButton(audioState: audioState),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16.0,
                      left: 16.0,
                      right: 24.0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Title & Place',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(width: 80),
                            Text(
                              'Length',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                        Divider(
                          height: 30,
                          thickness: 0.6,
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 24.0,
                        // Avoid to be hidden behind BottomPlayer (height: 90)
                        bottom: 96.0,
                      ),
                      // Remove unnecessary top padding set by default
                      // https://github.com/flutter/flutter/issues/14842#issuecomment-371344881
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: audioState.sounds.length,
                          itemExtent: 70,
                          itemBuilder: (context, _currentIndex) =>
                              AoiSoundListTile(
                            context: context,
                            audioState: audioState,
                            index: _currentIndex,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
