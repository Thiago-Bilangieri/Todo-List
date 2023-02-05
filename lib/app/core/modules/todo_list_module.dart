// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:provider/single_child_widget.dart';
import 'package:todo_list/app/core/modules/todo_list_page.dart';

abstract class TodoListModule {
  final Map<String, WidgetBuilder> _routers;
  final List<SingleChildWidget>? _bindings;
  TodoListModule({
    required Map<String, WidgetBuilder> routers,
    List<SingleChildWidget>? bindings,
  })  : _bindings = bindings,
        _routers = routers;

  Map<String, WidgetBuilder> get routers {
    return _routers.map(
      (key, value) => MapEntry(
        key,
        (_) => TodoListPage(
          bindings: _bindings,
          page: value,
        ),
      ),
    );
  }

  Widget getPage(String path, BuildContext context) {
    final widgetBuilder = _routers[path];
    if (widgetBuilder != null) {
      return TodoListPage(
        page: widgetBuilder,
        bindings: _bindings,
      );
    }
    throw Exception();
  }
}
