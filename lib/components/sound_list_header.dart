// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:aoku/components/shuffle_to_play_button.dart';

class SoundListHeader extends StatelessWidget {
  const SoundListHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            left: 16.0,
            right: 24.0,
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Center(
                    child: Text(
                      'Title & Place',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.7),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        'Length',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Divider(
                  height: 0.6,
                  thickness: 0.6,
                  indent: 4.0,
                  endIndent: 4.0,
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
