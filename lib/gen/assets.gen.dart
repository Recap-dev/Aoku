/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// ignore_for_file: directives_ordering,unnecessary_import

// 🐦 Flutter imports:
import 'package:flutter/widgets.dart';

class $ImagesGen {
  const $ImagesGen();

  /// File path: images/blue-blur-1.png
  AssetGenImage get blueBlur1 => const AssetGenImage('images/blue-blur-1.png');

  /// File path: images/blue-blur-2.png
  AssetGenImage get blueBlur2 => const AssetGenImage('images/blue-blur-2.png');

  /// File path: images/blue-blur.png
  AssetGenImage get blueBlur => const AssetGenImage('images/blue-blur.png');

  /// File path: images/icon.png
  AssetGenImage get icon => const AssetGenImage('images/icon.png');

  /// File path: images/like-btn.png
  AssetGenImage get likeBtn => const AssetGenImage('images/like-btn.png');

  /// File path: images/location-btn.png
  AssetGenImage get locationBtn =>
      const AssetGenImage('images/location-btn.png');

  /// File path: images/next-arrow.png
  AssetGenImage get nextArrow => const AssetGenImage('images/next-arrow.png');

  /// File path: images/orange-blur.png
  AssetGenImage get orangeBlur => const AssetGenImage('images/orange-blur.png');

  /// File path: images/play-btn.png
  AssetGenImage get playBtn => const AssetGenImage('images/play-btn.png');

  /// File path: images/prev-arrow.png
  AssetGenImage get prevArrow => const AssetGenImage('images/prev-arrow.png');

  /// File path: images/splash-background.png
  AssetGenImage get splashBackground =>
      const AssetGenImage('images/splash-background.png');

  /// File path: images/splash-foreground.png
  AssetGenImage get splashForeground =>
      const AssetGenImage('images/splash-foreground.png');
}

class Assets {
  Assets._();

  static const $ImagesGen images = $ImagesGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName);

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}
