import 'package:flutter/material.dart';
import 'package:todo_list/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/core/widgets/todo_list_field.dart';
import 'package:todo_list/app/modules/tasks/task_create_controller.dart';
import 'package:todo_list/app/modules/tasks/widget/calendar_button.dart';
import 'package:validatorless/validatorless.dart';

class TasksCreatePage extends StatefulWidget {
  final TaskCreateController _controller;

  TasksCreatePage({Key? key, required TaskCreateController controller})
      : _controller = controller,
        super(key: key);

  @override
  State<TasksCreatePage> createState() => _TasksCreatePageState();
}

class _TasksCreatePageState extends State<TasksCreatePage> {
  final _descriptionEC = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(changeNotifier: widget._controller).listener(
      context: context,
      successCallback: (notifier, listener) {
        listener.dispose();
        Navigator.pop(context);
      },
    );
  }

  @override
  void dispose() {
    _descriptionEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ))
        ],
        title: const Text(''),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Criar Task",
                  style: context.titleStyle.copyWith(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // TextFormField(),
              TodoListField(
                label: "",
                controller: _descriptionEC,
                validator: Validatorless.required("Descrição Obrigatoria"),
              ),
              const SizedBox(
                height: 20,
              ),
              CalendarButton()
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            final formValid = _formKey.currentState?.validate() ?? false;
            if (formValid) {
              widget._controller.save(_descriptionEC.text);
            }
          },
          backgroundColor: context.primaryColor,
          label: const Text(
            "Salvar Task",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
    );
  }
}
