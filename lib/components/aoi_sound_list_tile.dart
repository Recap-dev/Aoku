// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// 🌎 Project imports:
import 'package:aoku/components/skeleton.dart';
import 'package:aoku/models/audio_state.dart';
import 'package:aoku/pages/play_page.dart';

class AoiSoundListTile extends HookConsumerWidget {
  const AoiSoundListTile({
    Key? key,
    required this.index,
    this.isSkelton = false,
  }) : super(key: key);

  factory AoiSoundListTile.skelton() {
    return const AoiSoundListTile(
      index: 0,
      isSkelton: true,
    );
  }

  final int index;
  final bool? isSkelton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AudioState audioState = ref.watch(audioProvider);

    // Normal state
    if (isSkelton == false) {
      return Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 24.0,
          // Avoid to be hidden behind BottomPlayer (height: 90)
        ),
        child: Center(
          child: GestureDetector(
            onTap: () async {
              HapticFeedback.lightImpact();
              showCupertinoModalBottomSheet(
                context: context,
                builder: (context) => const PlayPage(),
              );
              await audioState.play(index);
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 24.0,
                    child: Visibility(
                      visible: index == audioState.currentIndex,
                      child: audioState.isPlaying
                          ? Icon(
                              CupertinoIcons.waveform,
                              color: Theme.of(context).colorScheme.onBackground,
                            )
                          : const SizedBox(),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          audioState.sounds[index].title,
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
                              CupertinoIcons.placemark_fill,
                              color: Theme.of(context).colorScheme.onBackground,
                              size: 12.0,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              '${audioState.sounds[index].city}, ${audioState.sounds[index].province}',
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
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
                      '${audioState.sounds[index].length.inMinutes.toString().padLeft(2, '  ')}:${audioState.sounds[index].length.inSeconds.remainder(60).toString().padLeft(2, '0')}',
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
        ),
      );
    }

    // Skelton state
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 24.0,
        // Avoid to be hidden behind BottomPlayer (height: 90)
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(width: 24.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Skeleton(width: 168.0, height: 12.0),
                  const SizedBox(height: 4.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        CupertinoIcons.placemark_fill,
                        color: Theme.of(context).colorScheme.onBackground,
                        size: 12.0,
                      ),
                      const SizedBox(width: 4.0),
                      const Skeleton(width: 48, height: 10),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12.0),
            const Skeleton(width: 32.0, height: 12.0),
          ],
        ),
      ),
    );
  }
}
