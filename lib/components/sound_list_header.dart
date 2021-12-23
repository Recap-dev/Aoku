import 'package:flutter/material.dart';

class SoundListHeader extends StatelessWidget {
  const SoundListHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Title & Place',
              style: TextStyle(
                fontSize: 12.0,
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
              ),
            ),
            const SizedBox(width: 80),
            Text(
              'Length',
              style: TextStyle(
                fontSize: 12.0,
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        Divider(
          height: 30,
          thickness: 0.6,
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
        ),
      ],
    );
  }
}
