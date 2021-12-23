import 'dart:ui';

import 'package:flutter/material.dart';

class FrostedBackground extends StatelessWidget {
  const FrostedBackground({
    Key? key,
  }) : super(key: key);

  @override
  Stack build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: SweepGradient(
              colors: [
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.primary,
              ],
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(color: Colors.transparent),
        ),
      ],
    );
  }
}
