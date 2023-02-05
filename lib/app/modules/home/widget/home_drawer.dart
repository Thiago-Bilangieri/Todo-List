import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/modules/auth/auth_provider.dart';
import 'package:todo_list/app/core/ui/message.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/services/user_service.dart';

class HomeDrawer extends StatelessWidget {
  final nameVM = ValueNotifier<String>("");
  HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration:
                BoxDecoration(color: context.primaryColor.withAlpha(70)),
            child: Row(
              children: [
                Selector<AuthProvider, String>(
                  selector: (Context, authProvider) {
                    return authProvider.user?.photoURL ??
                        "https://argumentumpericias.com.br/biblioteca/2019/09/sem-imagem-avatar.png";
                  },
                  builder: (context, value, child) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(value),
                      radius: 30,
                    );
                  },
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Selector<AuthProvider, String>(
                      selector: (Context, authProvider) {
                        return authProvider.user?.displayName ??
                            "Não informado";
                      },
                      builder: (context, value, child) {
                        return Text(value);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          ListTile(
            title: Text("Alterar o Nome"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Alterar Nome"),
                    content: TextField(
                      onChanged: (value) => nameVM.value = value,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (nameVM.value.isEmpty) {
                            Message.of(context).showInfo("Nome Obrigatorio");
                          } else {
                            Loader.show(context);
                            await context
                                .read<UserService>()
                                .updateDisplayName(nameVM.value);
                            Loader.hide();
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text("Alterar"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            title: Text("Sair"),
            onTap: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
    );
  }
}
