import 'package:flutter/material.dart';

class SoundListHeader extends StatelessWidget {
  const SoundListHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Divider(
          height: 30,
          thickness: 0.6,
          indent: 4.0,
          endIndent: 4.0,
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
        ),
      ],
    );
  }
}
