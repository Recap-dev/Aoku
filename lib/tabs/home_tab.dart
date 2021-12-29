// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:aoku/components/aoi_sound_list_tile.dart';
import 'package:aoku/components/bottom_player.dart';
import 'package:aoku/components/frosted_background.dart';
import 'package:aoku/components/full_screen_loading.dart';
import 'package:aoku/components/shuffle_to_play_button.dart';
import 'package:aoku/components/sound_list_header.dart';
import 'package:aoku/models/audio_state.dart';

class HomeTab extends HookConsumerWidget {
  const HomeTab({Key? key}) : super(key: key);

  static const String title = '聞く';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AudioState audioState = ref.watch(audioProvider);

    return Stack(
      children: [
        const FrostedBackground(),
        FutureBuilder(
          // 0 is a temporary index for init
          // Index will be overriden when play() called
          future: audioState.init(),
          builder: (context, snapshot) {
            if (snapshot.data != AudioStateInitStatus.done) {
              return const FullScreenLoading();
            }

            // Placing Listview.builder() into scroll view with other widgets
            // requires some tricks: https://stackoverflow.com/a/58725480/13676510
            return RefreshIndicator(
              onRefresh: () {
                HapticFeedback.lightImpact();
                return audioState.init(forceInit: true);
              },
              color: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.onBackground,
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      height: 168,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 24.0),
                          child: ShuffleToPlayButton(),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 16.0,
                        left: 16.0,
                        right: 24.0,
                      ),
                      child: SoundListHeader(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 24.0,
                        // Avoid to be hidden behind BottomPlayer (height: 90)
                        bottom: 60.0,
                      ),
                      // Remove unnecessary top padding set by default
                      // https://github.com/flutter/flutter/issues/14842#issuecomment-371344881
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: audioState.sounds.length,
                          itemExtent: 70,
                          itemBuilder: (context, _currentIndex) =>
                              AoiSoundListTile(index: _currentIndex),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: BottomPlayer(),
        ),
      ],
    );
  }
}
