import 'package:flutter/cupertino.dart';
import 'package:todo_list/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list/app/exception/auth_exception.dart';
import 'package:todo_list/app/services/user_service.dart';

class LoginController extends DefaultChangeNotifier {
  String? _infoMessage;
  final UserService _userService;

  LoginController({required UserService userService})
      : _userService = userService;
  bool get hasInfo => _infoMessage != null;
  String? get infoMessage => _infoMessage;

  Future<void> login(String email, String password) async {
    try {
      showLoadingAndResetState();
      _infoMessage = null;
      notifyListeners();
      final user = await _userService.login(email, password);
      if (user != null) {
        success();
      } else {
        setError("Usuario ou senha inválido");
      }
    } on AuthException catch (e, s) {
      debugPrint(e.message);
      debugPrint(s.toString());
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      showLoadingAndResetState();
      _infoMessage = null;
      notifyListeners();
      await _userService.forgoPassword(email);
      _infoMessage = "Resete de Senha enviado por email";
    } on AuthException catch (e) {
      setError(e.message);
    } catch (e) {
      setError("Erro ao resetar a senha!");
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> loginGoogle() async {
    try {
      showLoadingAndResetState();
      _infoMessage = null;
      notifyListeners();
      final user = await _userService.googleLogin();
      if (user != null) {
        success();
      } else {
        _userService.logout();
        setError("Erro ao realizar login com o Google");
      }
    } on AuthException catch (e) {
      setError(e.message);
      _userService.logout();
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
