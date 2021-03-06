// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';

// 🌎 Project imports:
import 'package:aoku/models/audio_state.dart';

class RepeatButton extends HookConsumerWidget {
  const RepeatButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AudioState audioState = ref.watch(audioProvider);

    return Container(
      width: 36,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: audioState.loopMode != LoopMode.off
            ? Theme.of(context).colorScheme.onBackground.withOpacity(0.4)
            : Colors.transparent,
      ),
      child: IconButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          audioState.setLoopMode();
        },
        icon: Icon(
          audioState.loopMode != LoopMode.one
              ? CupertinoIcons.repeat
              : CupertinoIcons.repeat_1,
          size: 16,
          color: audioState.loopMode != LoopMode.off
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
  }
}
