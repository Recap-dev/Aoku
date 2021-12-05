import 'package:aoku/models/audio_state.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AoiProgressBar extends HookConsumerWidget {
  const AoiProgressBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AudioState audioState = ref.watch(audioProvider);

    return ProgressBar(
      progress: audioState.position,
      total: audioState.duration,
      barHeight: 2,
      barCapShape: BarCapShape.square,
      thumbColor: Theme.of(context).colorScheme.onBackground,
      baseBarColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
      progressBarColor:
          Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
      bufferedBarColor: Colors.transparent,
      thumbRadius: 4,
      thumbGlowRadius: 6,
      timeLabelTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
        fontFamily: 'Noto-Serif-Japanese',
      ),
      timeLabelPadding: 10.0,
      onSeek: (Duration duration) {
        HapticFeedback.selectionClick();
        audioState.audioPlayer.seek(duration);
      },
      onDragStart: (ThumbDragDetails _) => HapticFeedback.lightImpact(),
      onDragEnd: () => HapticFeedback.mediumImpact(),
    );
  }
}
