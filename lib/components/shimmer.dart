// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// To paint one big shimmer across the screen, each ShimmerLoading widget needs
// to paint the same full-screen gradient based on the position of that
// ShimmerLoading widget on the screen.

// To be more precise, rather than assume that the shimmer should take up
// the entire screen, there should be some area that shares the shimmer.
// Maybe that area takes up the entire screen, or maybe it doesn’t. The way
// to solve this kind of problem in Flutter is to define another widget
// that sits above all of the ShimmerLoading widgets in the widget tree,
// and call it Shimmer. Then, each ShimmerLoading widget gets a reference to
// the Shimmer ancestor and requests the desired size and gradient to display.
class Shimmer extends StatefulWidget {
  static ShimmerState? of(BuildContext context) {
    return context.findAncestorStateOfType<ShimmerState>();
  }

  const Shimmer({
    Key? key,
    required this.linearGradient,
    this.child,
  }) : super(key: key);

  final LinearGradient linearGradient;
  final Widget? child;

  @override
  ShimmerState createState() => ShimmerState();
}

class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController.unbounded(vsync: this)
      ..repeat(
        min: -0.5,
        max: 1.5,
        period: const Duration(milliseconds: 1000),
      );
  }

  // Add methods to the ShimmerState class in order to provide access to the
  // linearGradient, the size of the ShimmerState’s RenderBox, and look up
  // the position of a descendant within the ShimmerState’s RenderBox.
  Gradient get gradient => LinearGradient(
        colors: widget.linearGradient.colors,
        stops: widget.linearGradient.stops,
        begin: widget.linearGradient.begin,
        end: widget.linearGradient.end,
        transform: _SlidingGradientTransform(
          slidePercent: _shimmerController.value,
        ),
      );

  bool get isSized => (context.findRenderObject() as RenderBox).hasSize;

  Size get size => (context.findRenderObject() as RenderBox).size;

  Listenable get shimmerChanges => _shimmerController;

  Offset getDescendantOffset({
    required RenderBox descendant,
    Offset offset = Offset.zero,
  }) {
    final shimmerBox = context.findRenderObject() as RenderBox;
    return descendant.localToGlobal(offset, ancestor: shimmerBox);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({
    required this.slidePercent,
  });

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
