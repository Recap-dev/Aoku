// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutterfire_ui/auth.dart';

enum AvailableOAuthProviders {
  google,
}

const Map<AvailableOAuthProviders, dynamic> kProviderConfigs = {
  AvailableOAuthProviders.google: GoogleProviderConfiguration(
    clientId: 'aoku-recap',
  ),
};

const String kGoogleMapsApiKey = 'AIzaSyCMqyHLwmc2ZeJHaQ8poJMjltg4dmrTdds';

const kShimmerGradient = LinearGradient(
  colors: [
    Color(0xFFEBEBF4),
    Color(0xFFF4F4F4),
    Color(0xFFEBEBF4),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  tileMode: TileMode.clamp,
);
