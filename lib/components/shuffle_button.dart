// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:aoku/models/audio_state.dart';

class ShuffleButton extends HookConsumerWidget {
  const ShuffleButton({
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
        color: audioState.shuffleModeEnabled
            ? Theme.of(context).colorScheme.onBackground.withOpacity(0.4)
            : Colors.transparent,
      ),
      child: Center(
        child: IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            audioState.toggleShuffleMode();
          },
          icon: Icon(
            CupertinoIcons.shuffle,
            size: 16,
            color: audioState.shuffleModeEnabled
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
    );
  }
}
