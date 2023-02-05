import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list/app/core/ui/message.dart';
import 'package:todo_list/app/core/widgets/todo_list_field.dart';
import 'package:todo_list/app/core/widgets/todo_list_logo.dart';
import 'package:todo_list/app/modules/auth/login/login_controller.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _emailFocus = FocusNode();
  @override
  void initState() {
    DefaultListenerNotifier(changeNotifier: context.read<LoginController>())
        .listener(
      context: context,
      everCallback: (notifier, listener) {
        if (notifier is LoginController) {
          if (notifier.hasInfo) {
            Message.of(context).showInfo(notifier.infoMessage!);
          }
        }
      },
      successCallback: ((notifier, listener) {}),
    );
    super.initState();
  }

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, constrains) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constrains.maxHeight,
                  minWidth: constrains.minWidth,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const TodoListLogo(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TodoListField(
                                label: "E-mail",
                                textInput: TextInputType.emailAddress,
                                focusNode: _emailFocus,
                                controller: _emailEC,
                                validator: Validatorless.multiple([
                                  Validatorless.required("Email obrigatorio!"),
                                  Validatorless.email("Email inválido")
                                ]),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TodoListField(
                                label: "Senha",
                                validator: Validatorless.multiple([
                                  Validatorless.required("Senha obrigatorio!"),
                                  Validatorless.min(
                                      6, "Digite ao menos 6 caracteres")
                                ]),
                                controller: _passwordEC,
                                obscureText: true,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      if (_emailEC.text.isNotEmpty) {
                                        context
                                            .read<LoginController>()
                                            .forgotPassword(_emailEC.text);
                                      } else {
                                        _emailFocus.requestFocus();
                                        Message.of(context).showError(
                                            "Digite seu email para recuperar a senha!");
                                      }
                                    },
                                    child: const Text("Exqueceu sua senha"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final formValid =
                                          _formKey.currentState?.validate() ??
                                              false;
                                      if (formValid) {
                                        context.read<LoginController>().login(
                                            _emailEC.text, _passwordEC.text);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text("Login"),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffF0F3F7),
                            border: Border(
                              top: BorderSide(
                                width: 2,
                                color: Colors.grey.withAlpha(50),
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              SignInButton(
                                Buttons.Google,
                                padding: const EdgeInsets.all(5),
                                onPressed: () {
                                  context.read<LoginController>().loginGoogle();
                                },
                                shape: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                text: "Continue com o Google",
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Não tem conta?",
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed("/register");
                                    },
                                    child: const Text("Cadastre-se"),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
