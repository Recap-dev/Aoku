import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PauseButton extends StatelessWidget {
  const PauseButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        CupertinoIcons.pause_fill,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      iconSize: 56,
    );
  }
}
