import 'package:aoku/pages/profile_page.dart';
import 'package:aoku/pages/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileButton extends HookConsumerWidget {
  const ProfileButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return GestureDetector(
          child: UserAvatar(
            size: 32.0,
            placeholderColor: Theme.of(context).colorScheme.onBackground,
          ),
          onTap: () => showCupertinoModalPopup(
            context: context,
            builder: (context) => CupertinoActionSheet(
              actions: [
                StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    // If user is not signed in
                    if (!snapshot.hasData) {
                      return CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInPage(),
                            ),
                          );
                        },
                        child: Text(
                          'サインイン',
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.white
                                : Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      );
                    } else {
                      return CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfilePage(),
                            ),
                          );
                        },
                        child: Text(
                          '設定',
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.white
                                : Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.pop(context),
                child: const Text('キャンセル'),
              ),
            ),
          ),
        );
      },
    );
  }
}
