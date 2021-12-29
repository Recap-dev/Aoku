// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileButton extends HookConsumerWidget {
  const ProfileButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If already signed in
        if (snapshot.hasData) {
          return UserAvatar(
            size: 32.0,
            placeholderColor: Theme.of(context).colorScheme.onBackground,
          );
        }

        // If not signed in
        return const Icon(
          CupertinoIcons.profile_circled,
          size: 32.0,
        );
      },
    );
  }
}
