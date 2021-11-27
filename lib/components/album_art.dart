import 'dart:ui';

import 'package:aoku/pages/play_page.dart';
import 'package:flutter/material.dart';

class AlbumArt extends StatelessWidget {
  const AlbumArt({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final PlayPage widget;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              widget.currentTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
