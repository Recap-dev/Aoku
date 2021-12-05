import 'package:aoku/models/auth_state.dart';
import 'package:aoku/pages/signup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SigninPage extends HookConsumerWidget {
  SigninPage({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SIGN IN'),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoTextFormFieldRow(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              placeholder: 'Email',
              showCursor: true,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            CupertinoTextFormFieldRow(
              autocorrect: false,
              keyboardType: TextInputType.visiblePassword,
              controller: _passwordController,
              obscureText: true,
              placeholder: 'Password',
              showCursor: true,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            CupertinoButton(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
              child: Text(
                'SIGN IN',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              onPressed: () async {
                bool result = await authState.signin(
                  _emailController.text,
                  _passwordController.text,
                  (err) => authState.showErrorDialog(
                    context,
                    'Failed to Sign In',
                    err,
                  ),
                );

                if (result == true) {
                  Navigator.of(context).pop();
                }
              },
            ),
            CupertinoButton(
              child: Text(
                'Create an account',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.7),
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignupPage(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
