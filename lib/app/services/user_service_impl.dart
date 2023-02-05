import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list/app/core/database/sqlite_connection_factory.dart';
import 'package:todo_list/app/repositories/tasks/tasks_repository.dart';
import 'package:todo_list/app/repositories/user/user_repository.dart';

import './user_service.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final TasksRepository _tasksRepository;

  UserServiceImpl(
      {required UserRepository userRepository,
      required TasksRepository tasksRepository})
      : _userRepository = userRepository,
        _tasksRepository = tasksRepository;

  @override
  Future<User?> register(String email, String password) =>
      _userRepository.register(email, password);

  @override
  Future<User?> login(String email, String password) =>
      _userRepository.login(email, password);

  @override
  Future<User?> forgoPassword(String email) =>
      _userRepository.forgotPassoword(email);

  @override
  Future<User?> googleLogin() => _userRepository.googleLogin();

  @override
  Future<void> logout() async {
    await _userRepository.logout();
    await _tasksRepository.deleteAll();
  }

  @override
  Future<void> updateDisplayName(String name) =>
      _userRepository.updateDisplayName(name);
}
