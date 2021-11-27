import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeartButton extends StatelessWidget {
  const HeartButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const IconButton(
      icon: Icon(
        CupertinoIcons.heart_fill,
        color: Colors.pink,
      ),
      onPressed: null,
      iconSize: 32.0,
    );
  }
}
