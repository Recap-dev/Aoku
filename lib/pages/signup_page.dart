import 'package:aoku/models/auth_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignupPage extends HookConsumerWidget {
  SignupPage({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SIGN UP'),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoTextFormFieldRow(
              autocorrect: false,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              placeholder: 'Email',
              showCursor: true,
              cursorColor: Theme.of(context).colorScheme.onBackground,
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
              cursorColor: Theme.of(context).colorScheme.onBackground,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            CupertinoTextFormFieldRow(
              autocorrect: false,
              keyboardType: TextInputType.name,
              controller: _displayNameController,
              textCapitalization: TextCapitalization.words,
              placeholder: 'Display Name',
              showCursor: true,
              cursorColor: Theme.of(context).colorScheme.onBackground,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            CupertinoButton(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
              child: Text(
                'SIGN UP',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              onPressed: () async {
                bool result = await authState.signup(
                  _emailController.text,
                  _displayNameController.text,
                  _passwordController.text,
                  (err) => authState.showErrorDialog(
                    context,
                    'Failed to Sign Up',
                    err,
                  ),
                );

                if (result == true) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
