import 'package:aoku/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      builder: (context, snapshot) => IconButton(
        icon: snapshot.hasData &&
                FirebaseAuth.instance.currentUser?.photoURL != null
            ? CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  FirebaseAuth.instance.currentUser?.photoURL as String,
                ),
              )
            : Icon(
                CupertinoIcons.profile_circled,
                color: Theme.of(context).colorScheme.onBackground,
              ),
        iconSize: 24.0,
        onPressed: () => showCupertinoModalPopup(
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
                            builder: (context) => SignInScreen(
                              headerBuilder: (context, constraints, _) =>
                                  Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.asset(
                                    'images/blue-blur-1.png',
                                  ),
                                ),
                              ),
                              providerConfigs: kProviderConfigs,
                              actions: [
                                AuthStateChangeAction<SignedIn>((context, _) {
                                  Navigator.pop(context);
                                }),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Sign In',
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
                            builder: (context) => ProfileScreen(
                              actions: [
                                SignedOutAction((context) {
                                  Navigator.pop(context);
                                }),
                              ],
                              providerConfigs: kProviderConfigs,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Profile',
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
              child: const Text('Cancel'),
            ),
          ),
        ),
      ),
    );
  }
}
