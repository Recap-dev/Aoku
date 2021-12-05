import 'package:aoku/models/auth_state.dart';
import 'package:aoku/pages/signin_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SigninButton extends HookConsumerWidget {
  const SigninButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authProvider);

    return IconButton(
      icon: Icon(
        CupertinoIcons.profile_circled,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      onPressed: () => showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            authState.user != null
                ? CupertinoActionSheetAction(
                    isDestructiveAction: true,
                    child: Text(
                      'Sign Out',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    onPressed: () {
                      authState.signOut();
                      Navigator.pop(context);
                    },
                  )
                : CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SigninPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ),
      ),
    );
  }
}
