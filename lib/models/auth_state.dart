import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final authProvider = ChangeNotifierProvider((_) => AuthState());

class AuthState extends ChangeNotifier {
  User? _user = auth.currentUser;
  final String? _uid = auth.currentUser?.uid;
  String? _email = auth.currentUser?.email;
  String? _displayName = auth.currentUser?.displayName;
  String? _photoUrl = auth.currentUser?.photoURL;

  User? get user => _user;
  String? get uid => _user?.uid;
  String? get email => _email;
  String? get displayName => _displayName;
  String? get photoUrl => _photoUrl;

  Future<bool> signup(
    String email,
    String displayName,
    String password,
    void Function(FirebaseAuthException err) errorCallback,
  ) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = auth.currentUser;
      await credential.user!.updateDisplayName(_displayName);
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> signin(
    String email,
    String password,
    void Function(FirebaseAuthException err) errorCallback,
  ) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      _user = auth.currentUser;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
      notifyListeners();
      return false;
    }
  }

  // Update the user's email
  Future<void> updateEmail(String email) async {
    try {
      await _user!.updateEmail(email);
      _email = email;
    } catch (e) {
      throw Exception('Update email failed: $e');
    }
    notifyListeners();
  }

  // Update the user's display name
  Future<void> updateDisplayName(String displayName) async {
    try {
      await _user!.updateDisplayName(displayName);
      _displayName = displayName;
    } catch (e) {
      throw Exception('Update display name failed: $e');
    }
    notifyListeners();
  }

  // Update the user's photo URL
  Future<void> updatePhotoUrl(String photoUrl) async {
    try {
      await _user!.updatePhotoURL(photoUrl);
      _photoUrl = photoUrl;
    } catch (e) {
      throw Exception('Update photo URL failed: $e');
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  void showErrorDialog(BuildContext context, String title, Exception e) {
    showCupertinoDialog<void>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
          ),
          content: Text(
            '${(e as dynamic).message}',
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
