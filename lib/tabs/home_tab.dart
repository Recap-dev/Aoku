// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:aoku/components/aoi_sound_list_tile.dart';
import 'package:aoku/components/bottom_player.dart';
import 'package:aoku/components/frosted_background.dart';
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
          future: audioState.init(),
          builder: (context, snapshot) {
            // Placing Listview.separated() into scroll view with other widgets
            // requires some tricks: https://stackoverflow.com/a/58725480/13676510
            return RefreshIndicator(
              onRefresh: () {
                HapticFeedback.lightImpact();
                return audioState.init(forceInit: true);
              },
              color: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.onBackground,
              child: SingleChildScrollView(
                physics: snapshot.data != AudioStateInitStatus.done
                    ? null
                    : const ScrollPhysics(),
                child: Column(
                  children: [
                    const SoundListHeader(),
                    const SizedBox(height: 16),
                    MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.separated(
                        physics: snapshot.data != AudioStateInitStatus.done
                            ? null
                            : const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data != AudioStateInitStatus.done
                            ? 20
                            : audioState.sounds.length,
                        separatorBuilder: (_, __) => const SizedBox(
                          height: 24.0,
                        ),
                        itemBuilder: (_, currentIndex) =>
                            snapshot.data != AudioStateInitStatus.done
                                ? AoiSoundListTile.skelton()
                                : AoiSoundListTile(index: currentIndex),
                      ),
                    ),
                    const SizedBox(height: 96),
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
