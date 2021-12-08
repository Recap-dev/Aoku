import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeartButton extends StatelessWidget {
  const HeartButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        CupertinoIcons.heart_fill,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      onPressed: null,
      iconSize: 24.0,
    );
  }
}
