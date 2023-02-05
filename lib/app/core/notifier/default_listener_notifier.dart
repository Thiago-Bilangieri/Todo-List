import 'package:flutter/cupertino.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:todo_list/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list/app/core/ui/message.dart';

class DefaultListenerNotifier {
  final DefaultChangeNotifier changeNotifier;
  DefaultListenerNotifier({
    required this.changeNotifier,
  });
  void listener({
    required BuildContext context,
    required SuccessVoidCallback successCallback,
    ErrorVoidCallback? errorCallback,
    EverVoidCallback? everCallback,
  }) {
    changeNotifier.addListener(() {
      everCallback != null ? everCallback(changeNotifier, this) : null;
      if (changeNotifier.loading) {
        Loader.show(context);
        Future.delayed(Duration(seconds: 3));
      } else {
        Loader.hide();
      }
      if (changeNotifier.hasError) {
        if (errorCallback != null) {
          errorCallback(changeNotifier, this);
        }
        Message.of(context).showError(changeNotifier.error ?? "Erro interno");
      } else if (changeNotifier.isSuccess) {
        if (successCallback != null) {
          successCallback(changeNotifier, this);
        }
      }
    });
  }

  void dispose() {
    changeNotifier.removeListener(() {});
  }
}

typedef SuccessVoidCallback = void Function(
  DefaultChangeNotifier notifier,
  DefaultListenerNotifier listener,
);
typedef ErrorVoidCallback = void Function(
  DefaultChangeNotifier notifier,
  DefaultListenerNotifier listener,
);
typedef EverVoidCallback = void Function(
  DefaultChangeNotifier notifier,
  DefaultListenerNotifier listener,
);
