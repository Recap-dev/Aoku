import 'package:aoku/pages/play_page.dart';
import 'package:flutter/material.dart';

class MapText extends StatelessWidget {
  const MapText({
    Key? key,
    required this.widget,
    this.onTap,
  }) : super(key: key);

  final PlayPage widget;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: null,
      child: Text(
        '${widget.city}, ${widget.province}',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
