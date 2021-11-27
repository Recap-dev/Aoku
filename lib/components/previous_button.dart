import 'package:aoku/pages/play_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreviousButton extends StatelessWidget {
  const PreviousButton({
    Key? key,
    required this.widget,
    this.onPressed,
  }) : super(key: key);

  final PlayPage widget;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.currentIndex == 0 ? null : onPressed,
      icon: Icon(
        CupertinoIcons.backward_fill,
        color: widget.currentIndex == 0
            ? Colors.white.withOpacity(0.4)
            : Colors.white,
      ),
      iconSize: 48,
    );
  }
}
