import 'package:aoku/components/frosted_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
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

              return Center(
                child: CupertinoButton.filled(
                  child: const Text('←'),
                  onPressed: () => Navigator.pop(context),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
