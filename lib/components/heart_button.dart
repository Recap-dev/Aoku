import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeartButton extends StatelessWidget {
  final Color color;
  final VoidCallback? onPressed;

  const HeartButton._({
    Key? key,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  // Enabled HeartButton constructor
  factory HeartButton.enabled({required VoidCallback? onPressed}) =>
      HeartButton._(
        key: const Key('HeartButton.enabled'),
        color: Colors.pink,
        onPressed: onPressed,
      );

  // Disabled HeartButton constructor
  factory HeartButton.disabled() => const HeartButton._(
        key: Key('HeartButton.disabled'),
        color: Colors.grey,
        onPressed: null,
      );

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        CupertinoIcons.heart_fill,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      onPressed: onPressed,
      iconSize: 24.0,
    );
  }
}
