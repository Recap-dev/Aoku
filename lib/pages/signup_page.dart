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
        title: const Text('新規登録'),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
            ),
          ),
          SafeArea(
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
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.3),
                  child: Text(
                    '登録',
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
                        '登録に失敗しました',
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
        ],
      ),
    );
  }
}
