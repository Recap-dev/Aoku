// π¦ Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// π¦ Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';

// π Project imports:
import 'package:aoku/components/frosted_background.dart';
import 'package:aoku/constants.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

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
                      Text(
                        'Aoku γΈγγγγ π',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      CupertinoButton.filled(
                        child: const Text('β'),
                        onPressed: () => Navigator.pop(context),
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
                        clientId:
                            kProviderConfigs[AvailableOAuthProviders.google]
                                .clientId,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
