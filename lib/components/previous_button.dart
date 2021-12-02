import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreviousButton extends StatelessWidget {
  const PreviousButton({
    Key? key,
    required this.currentIndex,
    this.onPressed,
  }) : super(key: key);

  final int currentIndex;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: currentIndex == 0 ? null : onPressed,
      icon: Icon(
        CupertinoIcons.backward_fill,
        color: currentIndex == 0
            ? Theme.of(context).colorScheme.onBackground.withOpacity(0.4)
            : Theme.of(context).colorScheme.onBackground,
      ),
      iconSize: 48,
    );
  }
}
