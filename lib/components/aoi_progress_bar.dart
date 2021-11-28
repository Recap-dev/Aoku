import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AoiProgressBar extends StatelessWidget {
  const AoiProgressBar({
    Key? key,
    required Duration currentPosition,
    required Duration currentDuration,
    required AudioPlayer audioPlayer,
  })  : _currentPosition = currentPosition,
        _currentDuration = currentDuration,
        _audioPlayer = audioPlayer,
        super(key: key);

  final Duration _currentPosition;
  final Duration _currentDuration;
  final AudioPlayer _audioPlayer;

  @override
  Widget build(BuildContext context) {
    return ProgressBar(
      progress: _currentPosition,
      total: _currentDuration,
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
      ),
      timeLabelPadding: 10.0,
      onSeek: (Duration duration) {
        HapticFeedback.selectionClick();
        _audioPlayer.seek(duration);
      },
      onDragStart: (ThumbDragDetails thumbDragDetails) =>
          HapticFeedback.lightImpact(),
      onDragEnd: () => HapticFeedback.mediumImpact(),
    );
  }
}
