import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MapButton extends StatelessWidget {
  const MapButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        CupertinoIcons.map_fill,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      onPressed: onPressed,
      iconSize: 32.0,
    );
  }
}
