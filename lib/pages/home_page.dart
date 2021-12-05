import 'dart:ui';

import 'package:aoku/models/audio_state.dart';
import 'package:aoku/pages/play_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:truncate/truncate.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AudioState audioState = ref.watch(audioProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.background,
        shadowColor: Colors.transparent,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          Align(
            alignment: const Alignment(1.0, -1.0),
            child: Image.asset(
              'images/orange-blur.png',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: const Alignment(-1.0, 1.0),
            child: Image.asset(
              'images/blue-blur-1.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: audioState.aoiSounds.length,
                itemExtent: 70,
                itemBuilder: (context, _currentIndex) {
                  return buildAoiSoundListTile(
                    context,
                    audioState,
                    _currentIndex,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildAoiSoundListTile(
    BuildContext context,
    AudioState audioState,
    int _index,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.onBackground,
                  width: 1.0,
                ),
              ),
              child: ListTile(
                title: Text(
                  truncate(
                    audioState.aoiSounds[_index].title,
                    15,
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                trailing: Text(
                  audioState.aoiSounds[_index].length.toString() + 'min',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                onTap: () {
                  audioState.initialIndex = _index;
                  audioState.play();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayPage(
                        initialIndex: _index,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
