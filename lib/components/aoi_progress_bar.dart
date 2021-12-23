import 'package:aoku/models/audio_state.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class AoiProgressBar extends HookConsumerWidget {
  const AoiProgressBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AudioState audioState = ref.watch(audioProvider);

    return ProgressBar(
      progress: audioState.initStatus != AudioStateInitStatus.done
          ? Duration.zero
          : audioState.position,
      total: audioState.initStatus == AudioStateInitStatus.done &&
              audioState.processingState == ProcessingState.ready
          ? audioState.duration
          : Duration.zero,
      buffered: audioState.initStatus == AudioStateInitStatus.done &&
              audioState.processingState == ProcessingState.ready
          ? audioState.buffered
          : Duration.zero,
      barHeight: 2,
      barCapShape: BarCapShape.round,
      thumbColor: Theme.of(context).colorScheme.onBackground,
      baseBarColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
      progressBarColor:
          Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
      bufferedBarColor:
          Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
      thumbRadius: 5,
      thumbGlowRadius: 6,
      timeLabelTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
        fontFamily: 'Noto-Serif-Japanese',
      ),
      timeLabelPadding: 10.0,
      onSeek: (Duration duration) {
        HapticFeedback.selectionClick();
        audioState.player.seek(duration);
      },
      onDragStart: (ThumbDragDetails _) => HapticFeedback.lightImpact(),
      onDragEnd: () => HapticFeedback.mediumImpact(),
    );
  }
}
