import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/core/widgets/todo_list_field.dart';
import 'package:todo_list/app/core/widgets/todo_list_logo.dart';
import 'package:todo_list/app/modules/auth/register/register_controller.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _globalKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _confirmPassowrdEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    final defaultListener = DefaultListenerNotifier(
        changeNotifier: context.read<RegisterController>());
    defaultListener.listener(
      context: context,
      successCallback: (notifier, listener) {},
    );
  }

  @override
  void dispose() {
    _emailEC.dispose();
    _confirmPassowrdEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: ClipOval(
              child: Container(
                color: context.primaryColor.withAlpha(20),
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.arrow_back_ios_outlined,
                  size: 20,
                  color: context.primaryColor,
                ),
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Todo List",
                style: TextStyle(
                  color: context.primaryColor,
                  fontSize: 10,
                ),
              ),
              Text(
                "Cadastro",
                style: TextStyle(
                  color: context.primaryColor,
                  fontSize: 15,
                ),
              )
            ],
          )),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.width * .5,
              child: const FittedBox(
                fit: BoxFit.fitHeight,
                child: TodoListLogo(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: Form(
                key: _globalKey,
                child: Column(
                  children: [
                    TodoListField(
                      validator: Validatorless.multiple([
                        Validatorless.required("Email obrigatório!"),
                        Validatorless.email("Email inválido"),
                      ]),
                      label: "E-mail",
                      controller: _emailEC,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TodoListField(
                      label: "Senha",
                      controller: _passwordEC,
                      obscureText: true,
                      validator: Validatorless.multiple([
                        Validatorless.required("Senha obrigatoria"),
                        Validatorless.min(
                            6, "Senha deve ter ao menos 6 caracteres"),
                      ]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TodoListField(
                      label: "Confirmar Senha",
                      controller: _confirmPassowrdEC,
                      obscureText: true,
                      validator: Validatorless.multiple([
                        Validatorless.compare(
                            _passwordEC, "Não esta igual a senha")
                      ]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          final formValid =
                              _globalKey.currentState?.validate() ?? false;
                          if (formValid) {
                            context
                                .read<RegisterController>()
                                .registerUser(_emailEC.text, _passwordEC.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text("Salvar"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
