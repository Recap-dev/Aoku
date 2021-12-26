import 'package:flutterfire_ui/auth.dart';

enum AvailableOAuthProviders {
  google,
}

const Map<AvailableOAuthProviders, dynamic> kProviderConfigs = {
  AvailableOAuthProviders.google: GoogleProviderConfiguration(
    clientId: 'aoku-recap',
  ),
};
