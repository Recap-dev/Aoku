// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:

class Skeleton extends StatelessWidget {
  const Skeleton({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.black.withOpacity(0.05),
      ),
    );
  }
}
