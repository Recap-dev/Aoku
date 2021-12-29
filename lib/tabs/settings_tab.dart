// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';

// 🌎 Project imports:
import 'package:aoku/components/frosted_background.dart';
import 'package:aoku/constants.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  static const String title = '設定';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const FrostedBackground(),
        StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // If already signed in
            if (snapshot.hasData) {
              return SizedBox.expand(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const UserAvatar(
                      size: 120.0,
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser!.displayName ?? '未設定',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    CupertinoButton(
                      child: Text(
                        'サインアウト',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      onPressed: () => FirebaseAuth.instance.signOut(),
                    ),
                  ],
                ),
              );
            }

            // If not signed in
            return SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: GoogleSignInButton(
                      clientId: kProviderConfigs[AvailableOAuthProviders.google]
                          .clientId,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
