import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(
        CupertinoIcons.play_fill,
        color: Colors.white,
      ),
      iconSize: 56,
    );
  }
}
