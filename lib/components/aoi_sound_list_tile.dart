import 'package:aoku/models/audio_state.dart';
import 'package:aoku/pages/play_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AoiSoundListTile extends StatelessWidget {
  const AoiSoundListTile({
    Key? key,
    required this.context,
    required this.audioState,
    required this.index,
  }) : super(key: key);

  final BuildContext context;
  final AudioState audioState;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
