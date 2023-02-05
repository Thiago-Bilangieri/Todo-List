// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserService {
  Future<User?> register(String email, String password);
  Future<User?> login(String email, String password);
  Future<User?> forgoPassword(String email);
  Future<User?> googleLogin();
  Future<void> logout();
  Future<void> updateDisplayName(String name);
}
