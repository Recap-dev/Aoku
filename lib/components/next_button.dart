import 'package:aoku/pages/play_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    Key? key,
    required this.widget,
    this.onPressed,
  }) : super(key: key);

  final PlayPage widget;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed:
          widget.currentIndex == widget.aoiSounds.length - 1 ? null : onPressed,
      icon: Icon(
        CupertinoIcons.forward_fill,
        color: widget.currentIndex == widget.aoiSounds.length - 1
            ? Colors.white.withOpacity(0.4)
            : Colors.white,
      ),
      iconSize: 48,
    );
  }
}
