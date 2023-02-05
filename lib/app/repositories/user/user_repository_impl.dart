// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list/app/exception/auth_exception.dart';

import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  FirebaseAuth _firebaseAuth;
  UserRepositoryImpl({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;
  @override
  Future<User?> register(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      // if (e.code == "email-already-exists") {
      if (e.code == "email-already-in-use") {
        final loginTypes =
            await _firebaseAuth.fetchSignInMethodsForEmail(email);
        if (loginTypes.contains("password")) {
          throw AuthException(
              message: "Email já utilizado, por favor utilize outro E-mail!");
        } else {
          throw AuthException(
              message:
                  "Voce se cadastrou no TodoList pelo google, favor logar por ele!");
        }
      }
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      throw AuthException(message: e.message ?? "Erro ao realizar login");
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      throw AuthException(message: e.message ?? "Erro ao realizar login");

      // TODO
    }
  }

  @override
  Future<User?> forgotPassoword(String email) async {
    try {
      final loginMethods =
          await _firebaseAuth.fetchSignInMethodsForEmail(email);
      if (loginMethods.contains("password")) {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      } else if (loginMethods.contains("google")) {
        throw AuthException(message: "Cadastro realizado com o Google");
      } else {
        throw AuthException(message: "Email não cadastrado");
      }
    } on PlatformException catch (e, s) {
      throw AuthException(message: "Erro ao resetar senha!");
    }
  }

  @override
  Future<User?> googleLogin() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final loginMethods =
            await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);
        if (loginMethods.contains("password")) {
          throw AuthException(
              message: "Voce Utilizou o email para cadastrar no TodoList");
        } else {
          final googleAuth = await googleUser.authentication;
          final firebaseCredential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
          var userCredential =
              await _firebaseAuth.signInWithCredential(firebaseCredential);
          return userCredential.user;
        }
      }
    } on FirebaseAuthException catch (e, s) {
      debugPrint(e.message);
      debugPrint(s.toString());
      if (e.code == "account-exists-with-different-credential") {
        throw AuthException(
            message:
                "Login inválido, voce ja se registrou no TodoList com o Email");
      } else {
        throw AuthException(message: "Erro ao realizar Login");
      }
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    _firebaseAuth.signOut();
  }

  @override
  Future<void> updateDisplayName(String name) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      user.reload();
    }
  }
}
