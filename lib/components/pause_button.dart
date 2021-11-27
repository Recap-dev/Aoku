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
      icon: const Icon(
        CupertinoIcons.pause_fill,
        color: Colors.white,
      ),
      iconSize: 56,
    );
  }
}
